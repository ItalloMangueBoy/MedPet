defmodule MedPet.Accounts.Pet do
  use Ecto.Schema
  alias MedPet.Accounts.User
  import Ecto.Changeset

  schema "pets" do
    field :name, :string
    field :color, :string
    field :specie, :string
    field :breed, :string
    field :sex, :string
    field :age, :integer

    belongs_to :user, User

    timestamps()
  end

  @type t :: %__MODULE__{
          id: integer() ,
          name: String.t(),
          color: String.t(),
          specie: String.t(),
          breed: String.t(),
          sex: String.t(),
          age: integer(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  # CHANGESETS

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :specie, :breed, :age, :color, :sex])
    |> validate_specie()
    |> validate_age()
    |> validate_sex()
  end

  # VALIDATIONS

  defp validate_specie(changeset) do
    changeset
    |> validate_required([:specie], message: "insira a especie do pet")
  end

  defp validate_age(changeset) do
    changeset
    |> validate_number(:age, greater_than: 0, message: "a idade do pet não pode ser menor que 0")
  end

  defp validate_sex(changeset) do
    changeset
    |> validate_required([:sex], message: "insira o sexo do pet")
    |> validate_format(:sex, ~r"^[M|F]{1}$", message: "sexo invalido")
  end
end
