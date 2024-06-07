defmodule MedPetWeb.Router do
  use MedPetWeb, :router

  alias MedPet.Guardian.Pipeline.EnsureAuth
  alias MedPet.Guardian.Pipeline.EnsureNotAuth
  alias MedPet.Guardian.Pipeline.MaybeAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MedPetWeb do
    pipe_through [:api, MaybeAuth]

    resources "/users", UserController, only: [:show]
  end

  scope "/api", MedPetWeb do
    pipe_through [:api, EnsureNotAuth]

    resources "/users", UserController, only: [:create] do
      resources "/pets", PetController, only: [:index]
    end

    post "/login", UserController, :login
  end

  scope "/api", MedPetWeb do
    pipe_through [:api, EnsureAuth]

    resources "/users", UserController, only: []
    get "/current/users", UserController, :current

    resources "/pets", PetController, only: [:create]
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:med_pet, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: MedPetWeb.Telemetry
    end
  end
end
