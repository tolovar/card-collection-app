defmodule BackendWeb.AuthErrorHandler do
  import Plug.Conn

  # gestisco gli errori di autenticazione
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, ~s({"error": "autenticazione richiesta"}))
  end
end
