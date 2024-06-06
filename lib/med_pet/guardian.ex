defmodule MedPet.Guardian do
  use Guardian, otp_app: :med_pet

  alias MedPet.Accounts
  alias MedPet.Accounts.User

  @spec subject_for_token(User.t(), any) :: {:ok, String.t()}
  def subject_for_token(%User{id: id}, _claims),
    do: {:ok, to_string(id)}

  def subject_for_token(_, _),
    do: {:error, :unhandled_resource_type}

  @spec resource_from_claims(map) :: {:error, :unhandled_resource_type} | {:ok, %User{} | nil}
  def resource_from_claims(%{"sub" => id}) do
    {:ok, Accounts.get_user!(id)}
  rescue
    Ecto.NoResultsError ->
      {:error, :resource_not_found}
  end

  def resource_from_claims(_),
    do: {:error, :unhandled_resource_type}
end
