defmodule MedPet.Guardian.Pipeline.EnsureAuth do
  use Guardian.Plug.Pipeline,
    otp_app: :med_pet,
    module: MedPet.Guardian,
    error_handler: MedPet.ErrorHandler

  @claims %{typ: "access"}

  plug Guardian.Plug.VerifyHeader, claims: @claims, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
