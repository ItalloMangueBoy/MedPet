defmodule MedPetWeb.UserController do
  use MedPetWeb, :controller

  alias MedPet.Guardian
  alias MedPet.Accounts
  alias MedPet.Accounts.User

  action_fallback MedPetWeb.FallbackController

  def create(conn, %{"data" => attrs}) do
    with {:ok, user} <-
           Accounts.create_user(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def login(conn, %{"data" => attrs}) do
    credentials = %{
      email: attrs["email"],
      password: attrs["password"]
    }

    with {:ok, user} <- Accounts.get_user_by_credentials(credentials),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user, %{"typ" => "access"}) do
      render(conn, "token.json", token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user(id) do
      render(conn, :show, user: user)
    end
  end

  def current(conn, _params) do
    with {:ok, user} <- Accounts.get_current_user(conn) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
