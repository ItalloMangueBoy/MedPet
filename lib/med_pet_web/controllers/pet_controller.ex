defmodule MedPetWeb.PetController do
  use MedPetWeb, :controller

  alias MedPet.Accounts
  alias MedPet.Accounts.Pet

  action_fallback MedPetWeb.FallbackController

  def index(conn, _params) do
    pets = Accounts.list_pets()
    render(conn, :index, pets: pets)
  end

  def create(conn, %{"data" => attrs}) do
    with {:ok, user} <- Accounts.get_current_user(conn),
         {:ok, pet} <- Accounts.create_pet(attrs, user) do
      conn
      |> put_status(:created)
      |> render("show.json", pet: pet)
    end
  end

  def show(conn, %{"id" => id}) do
    pet = Accounts.get_pet!(id)
    render(conn, :show, pet: pet)
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    pet = Accounts.get_pet!(id)

    with {:ok, %Pet{} = pet} <- Accounts.update_pet(pet, pet_params) do
      render(conn, :show, pet: pet)
    end
  end

  def delete(conn, %{"id" => id}) do
    pet = Accounts.get_pet!(id)

    with {:ok, %Pet{}} <- Accounts.delete_pet(pet) do
      send_resp(conn, :no_content, "")
    end
  end
end
