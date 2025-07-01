defmodule BackendWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # endpoint di default
      @endpoint BackendWeb.Endpoint

      use BackendWeb, :verified_routes

      # importo funzioni utili per i test
      import Plug.Conn
      import Phoenix.ConnTest
      import BackendWeb.ConnCase
    end
  end

  setup tags do
    Backend.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
