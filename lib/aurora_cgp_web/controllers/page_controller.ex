defmodule AuroraCGPWeb.PageController do
  use AuroraCGPWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def register(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :register)
  end
end
