defmodule MedPetWeb.PetJSON do
  alias MedPet.Accounts.Pet

  @doc """
  Renders a list of pets.
  """
  def index(%{pets: pets}) do
    %{data: for(pet <- pets, do: data(pet))}
  end

  @doc """
  Renders a single pet.
  """
  def show(%{pet: pet}) do
    %{data: data(pet)}
  end

  defp data(%Pet{} = pet) do
    %{
      id: pet.id,
      name: pet.name,
      specie: pet.specie,
      breed: pet.breed,
      age: pet.age,
      color: pet.color,
      sex: pet.sex
    }
  end
end
