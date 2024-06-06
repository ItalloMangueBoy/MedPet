defmodule MedPet.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Hex.API.User
  alias MedPet.Repo
  alias MedPet.Guardian
  alias MedPet.Accounts.User
  alias MedPet.Accounts.Pet

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) do
    try do
      {:ok, Repo.get!(User, id)}
    rescue
      Ecto.NoResultsError -> {:error, :not_found}
    end
  end

  @doc """
  Gets {:ok, %User{}} whith given credentials.
  Returns {:error, :invalid_credentials} if the User does not exist or password is incorrect.

  ## Examples

  iex> get_user_by_credentials(%{email: email, password: password})
  %User{}

  iex> get_user_by_credentials(%{})
  {:error, :invalid_credentials}

  """
  @spec get_user_by_credentials(%{email: String.t(), password: String.t()}) ::
          {:ok, User.t()} | {:error, :invalid_credentials}
  def get_user_by_credentials(%{email: email, password: password}) do
    with user = %User{} <- Repo.get_by(User, email: email),
         true <- Argon2.verify_pass(password, user.password) do
      {:ok, user}
    else
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      _ ->
        {:error, :invalid_credentials}
    end
  end

  @doc """
  Returns the authenticated user.
  Retrurns {:error, :unauthorized} when user cant be finded

  ## Examples

  iex> get_current_user(conn)
  {:ok, %User{}}

  iex> get_current_user(%{})
  {:error, :unauthorized}

  """
  @spec get_current_user(Plug.Conn.t()) :: {:ok, User.t()} | {:error, :unauthorized}
  def get_current_user(conn) do
    case Guardian.Plug.current_resource(conn) do
      user -> {:ok, user}
      _ -> {:error, :unauthorized}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias MedPet.Accounts.Pet

  @doc """
  Returns the list of pets.

  ## Examples

      iex> list_pets()
      [%Pet{}, ...]

  """
  def list_pets do
    Repo.all(Pet)
  end

  @doc """
  Gets a single pet.

  Raises `Ecto.NoResultsError` if the Pet does not exist.

  ## Examples

      iex> get_pet!(123)
      %Pet{}

      iex> get_pet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pet!(id), do: Repo.get!(Pet, id)

  @doc """
  Creates a pet.

  ## Examples

      iex> create_pet(%{field: value})
      {:ok, %Pet{}}

      iex> create_pet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pet(attrs = %{user_id: user_id} \\ %{}) do
    with {:ok, user} <- get_user(user_id) do
      create_pet(attrs, user)
    else
      e -> e
    end
  end

  def create_pet(attrs, user = %User{}) do
    user
    |> Ecto.build_assoc(:pets)
    |> Pet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pet.

  ## Examples

      iex> update_pet(pet, %{field: new_value})
      {:ok, %Pet{}}

      iex> update_pet(pet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pet(%Pet{} = pet, attrs) do
    pet
    |> Pet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pet.

  ## Examples

      iex> delete_pet(pet)
      {:ok, %Pet{}}

      iex> delete_pet(pet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pet(%Pet{} = pet) do
    Repo.delete(pet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pet changes.

  ## Examples

      iex> change_pet(pet)
      %Ecto.Changeset{data: %Pet{}}

  """
  def change_pet(%Pet{} = pet, attrs \\ %{}) do
    Pet.changeset(pet, attrs)
  end
end
