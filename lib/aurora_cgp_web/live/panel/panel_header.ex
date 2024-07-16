defmodule PanelHeaderComponent do
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  def update(assigns, socket) do
    socket =
      socket
      |> assign(:context, assigns.context)
      |> assign(:uri, assigns.uri)
      |> assign(:ou, AuroraCGP.Projector.OU.get_ou_by_id(assigns.context))
      |> assign(:ou_list, AuroraCGP.Projector.OU.get_all_ou())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="card w-full flex flex-row h-fit justify-center items-center">
      <div class="flex flex-col grow">
        <h2 class="bg-white w-fit text-black px-2 py-0.5 font-bold rounded"><%= @ou.ou_id %></h2>

        <h1 class="text-4xl"><%= @ou.ou_name %></h1>

        <h2><%= @ou.ou_goal %></h2>
      </div>

      <div>
        <button class="justify-center items-center text-lg primary">
          <FontAwesome.LiveView.icon name="arrows-up-down" type="solid" class="h-5 w-5" /> Navegar
        </button>
      </div>
    </section>
    """
  end

  def show_navigate(js \\ %JS{}) do
    js
    |> JS.toggle_class("hidden", to: "#dropdown")
  end
end
