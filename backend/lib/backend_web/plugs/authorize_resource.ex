defmodule BackendWeb.Plugs.AuthorizeResource do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    resource = conn.assigns[opts[:resource]]
    user = Guardian.Plug.current_resource(conn)
    if resource && user && Map.get(resource, :user_id) == user.id do
      conn
    else
      conn
      |> Phoenix.Controller.put_status(:forbidden)
      |> Phoenix.Controller.json(%{error: "Non autorizzato"})
      |> halt()
    end
  end
end