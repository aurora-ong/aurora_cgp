defmodule AuroraCGPWeb.Router do
  use AuroraCGPWeb, :router

  import AuroraCGPWeb.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AuroraCGPWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_person
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AuroraCGPWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuroraCGPWeb do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:aurora_cgp, :dev_routes) do

    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", AuroraCGPWeb do
    pipe_through [:browser, :redirect_if_person_is_authenticated]

    live_session :redirect_if_person_is_authenticated,
      on_mount: [{AuroraCGPWeb.Auth, :redirect_if_person_is_authenticated}] do
      live "/persons/log_in", PersonLoginLive, :new
    end

    post "/persons/log_in", PersonSessionController, :create
  end

  scope "/", AuroraCGPWeb do
    pipe_through [:browser, :require_authenticated_person]

    live_session :require_authenticated_person,
      on_mount: [{AuroraCGPWeb.Auth, :ensure_authenticated}] do

    end
  end

  scope "/", AuroraCGPWeb do
    pipe_through [:browser]

    delete "/persons/log_out", PersonSessionController, :delete

    live_session :current_person,
      on_mount: [{AuroraCGPWeb.Auth, :mount_current_person}] do
    end
  end

  scope "/panel", AuroraCGPWeb do
    pipe_through [:browser]

    live_session :panel,
      on_mount: [{AuroraCGPWeb.Auth, :mount_current_person}] do
        live "/", PanelLive, :index
        live "/inicio", PanelLive, :index
        live "/miembros", PanelLive, :index
    end
  end
end
