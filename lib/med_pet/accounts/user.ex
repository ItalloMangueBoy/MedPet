defmodule MedPet.Accounts.User do
  use Ecto.Schema
  alias MedPet.Accounts.Pet
  alias MedPet.Helpers.Regex.User, as: Rx
  import Ecto.Changeset

  @fields [:name, :cpf, :tel, :email, :password]

  schema "users" do
    field :name, :string
    field :password, :string, redact: true, load_in_query: false
    field :cpf, :string
    field :tel, :string
    field :email, :string

    has_many :pets, Pet

    timestamps()
  end

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          cpf: String.t(),
          tel: String.t(),
          email: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  # CHANGESETS

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  @spec changeset(t(), map(), keyword()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = user, attrs, opts \\ []) do
    confirm? = Keyword.get(opts, :confirm?, false)
    confirm_email? = Keyword.get(opts, :confirm_email?, confirm?)
    confirm_password? = Keyword.get(opts, :confirm_password?, confirm?)

    permitted_fields = Keyword.get(opts, :permitted_fields, @fields)

    user
    |> cast(attrs, permitted_fields)
    |> validate_name()
    |> validate_password(confirm?: confirm_password?)
    |> validate_cpf()
    |> validate_tel()
    |> validate_email(confirm?: confirm_email?)
  end

  @spec create_changeset(t(), map()) :: Ecto.Changeset.t()
  def create_changeset(user, attrs),
    do: changeset(user, attrs, confirm?: true) |> hash_password()

  # VALIDATIONS

  @spec validate_name(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_name(changeset) do
    changeset
    |> validate_required([:name], message: "insira seu nome")
  end

  @spec validate_password(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_password(changeset, opts \\ []) do
    confirm? = Keyword.get(opts, :confirm?, false)

    changeset
    |> validate_required([:password], message: "insira sua senha")
    |> validate_confirmation(:password, required: confirm?, message: "as senhas não batem")
  end

  @spec validate_cpf(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_cpf(changeset) do
    changeset
    |> validate_required([:cpf], message: "insira seu cpf")
    |> validate_format(:cpf, Rx.cpf(), message: "cpf invalido")
    |> unique_constraint(:cpf, message: "este cpf ja foi registrado")
  end

  @spec validate_tel(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_tel(changeset) do
    changeset
    |> validate_required([:tel], message: "insira seu numero de telefone")
    |> validate_format(:tel, Rx.tel(), message: "numero de telefone invalido")
    |> unique_constraint(:tel, message: "este numero de telefone ja foi registrado")
  end

  @spec validate_email(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_email(changeset, opts \\ []) do
    confirm? = Keyword.get(opts, :confirm?, false)

    changeset
    |> validate_required([:email], message: "insira seu email")
    |> validate_confirmation(:email, required: confirm?, message: "os emails não batem")
    |> validate_length(:email, max: 254, message: "email invalido")
    |> validate_format(:email, Rx.email(), "email invalido")
    |> unique_constraint(:email, message: "este email ja foi registrado")
  end

  # PARSERS

  @spec hash_password(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp hash_password(%Ecto.Changeset{valid?: true} = changeset) do
    hash =
      changeset
      |> get_change(:password)
      |> Argon2.hash_pwd_salt()

    change(changeset, password: hash)
  end

  defp hash_password(changeset), do: changeset
end
