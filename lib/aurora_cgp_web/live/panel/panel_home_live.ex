defmodule HomePanelComponent do
  # In Phoenix apps, the line is typically: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def update(assigns, socket) do

    socket =
      socket
      |> assign(:context, assigns.context)
      |> assign(:ou, AuroraCGP.Projector.OU.get_ou_by_id(assigns.context))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="card w-4/6 flex flex-col h-fit justify-center items-center">
      <h1>Inicio</h1>
      <h2><%= @ou.ou_description %></h2>
      <h2><%= @ou.created_at %></h2>
    </section>
    """
  end
end
