defmodule MembersPanelComponent do
  # In Phoenix apps, the line is typically: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def mount(socket) do

    socket =
      socket
      |> assign(:filter, "all")

    {:ok, socket}
  end

  def update(assigns, socket) do
    IO.inspect("Uodate")

    socket =
      socket
      |> assign(:context, assigns.context)
      |> assign(:members, AuroraCGP.Projector.Membership.get_all_membership_by_uo(assigns.context))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="card w-4/6 flex flex-col h-fit justify-center items-center">
    <%= inspect(@filter) %>
      <div class="flex w-full h-12 flex-row">
        <div class="flex w-fit grow">
          <ul class="flex flex-row gap-3 items-center tabs">
            <li class={if @filter == "all", do: "active", else: ""}><a phx-click="update_filter" phx-value-filter="all" phx-target={@myself}>Todos</a></li>

            <li class={if @filter == "new", do: "active", else: ""}><a phx-click="update_filter" phx-value-filter="new" phx-target={@myself}>Nuevos</a></li>

            <li class={if @filter == "active", do: "active", else: ""}><a phx-click="update_filter" phx-value-filter="active" phx-target={@myself}>Activos</a></li>

            <li class={if @filter == "inactive", do: "active", else: ""}><a phx-click="update_filter" phx-value-filter="inactive" phx-target={@myself}>Inactivos</a></li>
          </ul>
        </div>

        <div class="flex w-fit">
          <button class="justify-center items-center text-lg primary">
            <FontAwesome.LiveView.icon name="hand" type="solid" class="h-5 w-5" /> Gobernar
          </button>
        </div>
      </div>
       <hr class="my-5" />

       <%= for m <- @members do %>

       <%= m.person.person_id %>
        <%= m.person.person_name %>
       <% end %>
    </section>
    """
  end

  def handle_event("update_filter", %{"filter" => filter}, socket) do
    IO.inspect(filter, label: "QQ")

    {:noreply, assign(socket, filter: filter)}
  end
end
