defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug BackendWeb.Plugs.AuthPipeline
    plug BackendWeb.Plugs.LoadUserFromToken
  end

  pipeline :jwt_authenticated do
    plug BackendWeb.AuthPipeline
  end

  # le rotte pubbliche (registrazione e login) restano fuori
  scope "/api", BackendWeb do
    pipe_through :api

    post "/users/register", AuthController, :register
    post "/users/login", AuthController, :login
    post "/users/forgot_password", AuthController, :forgot_password # reset password non protetto

    pipe_through :jwt_authenticated

    # le rotte che voglio proteggere
    resources "/cards", CardController, except: [:new, :edit]
    resources "/decks", DeckController, except: [:new, :edit]
    resources "/user_cards", UserCardController, except: [:new, :edit]
    resources "/deck_cards", DeckCardController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/auth", AuthController, only: [:logout] # solo logout protetto
    post "/auth/refresh", AuthController, :refresh # refresh token protetto
    post "/auth/change_password", AuthController, :change_password # cambio password protetto
    post "/auth/update_profile", AuthController, :update_profile # aggiorno profilo protetto
  end

  # abilito LiveDashboard e MailboxPreview in ambiente di sviluppo
  if Application.compile_env(:backend, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
