defmodule MedPetWeb.UserJSON do
  alias MedPet.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def token(%{token: token}) do
    %{data: %{token: token}}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      cpf: user.cpf,
      tel: user.tel,
      email: user.email,
      password: user.password
    }
  end
end
