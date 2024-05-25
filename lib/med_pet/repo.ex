defmodule MedPet.Repo do
  use Ecto.Repo,
    otp_app: :med_pet,
    adapter: Ecto.Adapters.Postgres
end
