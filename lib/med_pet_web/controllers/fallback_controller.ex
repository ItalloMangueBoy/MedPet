defmodule MedPetWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use MedPetWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: MedPetWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: MedPetWeb.ErrorHTML, json: MedPetWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(422)
    |> put_view(MedPetWeb.ErrorJSON)
    |> render("invalid_credentials.json")
  end
end
