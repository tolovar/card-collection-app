defmodule BackendWeb.Plugs.LoadUserFromToken do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    claims = Guardian.Plug.current_claims(conn)
    if user_map = claims["user"] do
      assign(conn, :current_user, user_map)
    else
      conn
    end
  end
end