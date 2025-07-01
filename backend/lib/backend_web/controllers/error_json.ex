defmodule BackendWeb.ErrorJSON do
  # qui gestisco la risposta in caso di errore su richieste JSON
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
