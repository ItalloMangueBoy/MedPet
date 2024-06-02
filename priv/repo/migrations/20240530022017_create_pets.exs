defmodule MedPet.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string
      add :specie, :string, null: false
      add :breed, :string
      add :age, :integer
      add :color, :string
      add :sex, :string, null: false, size: 1

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
