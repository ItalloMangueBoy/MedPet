# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :med_pet,
  ecto_repos: [MedPet.Repo]

# Configures the endpoint
config :med_pet, MedPetWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: MedPetWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: MedPet.PubSub,
  live_view: [signing_salt: "eFUsXvLc"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Config guardian
config :med_pet, MedPet.Guardian,
  issuer: "med_pet",
  secret_key: "95QpI/BTkD4aIm+r+SJ5eYfeYLhpJKaUerqf0Sx5DZ/A70+DsH7WTV13G3WPURRb"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
