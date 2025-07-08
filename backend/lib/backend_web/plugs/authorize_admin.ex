defmodule BackendWeb.Plugs.AuthorizeAdmin do
  import Plug.Conn
  import Phoenix.Controller

  alias BackendWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _opts) do
    user = conn.assigns[:current_user]

    # controllo se l'utente è admin
    if user && user.is_admin do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Accesso negato. Richiesti privilegi di amministratore."})
      |> halt()
    end
  end
end
