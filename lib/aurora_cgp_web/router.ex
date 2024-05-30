defmodule AuroraCGPWeb.Router do
  use AuroraCGPWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AuroraCGPWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AuroraCGPWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/registro", PageController, :register
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
end
