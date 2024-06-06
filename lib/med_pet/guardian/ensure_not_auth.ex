defmodule MedPet.Guardian.Pipeline.EnsureNotAuth do
  use Guardian.Plug.Pipeline,
    otp_app: :med_pet,
    module: MedPet.Guardian,
    error_handler: MedPet.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureNotAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
