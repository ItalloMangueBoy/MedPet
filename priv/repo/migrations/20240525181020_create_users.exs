defmodule MedPet.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  alias MedPet.Regex.User, as: Rx

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, null: false, primary_key: true
      add :name, :string, null: false
      add :cpf, :string, null: false, size: 11
      add :tel, :string, null: false, size: 14
      add :email, :string, null: false, size: 254
      add :password, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:cpf])
    create unique_index(:users, [:tel])
    create unique_index(:users, [:email])
  end
end
