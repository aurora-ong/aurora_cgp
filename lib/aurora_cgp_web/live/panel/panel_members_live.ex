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
      |> assign(
        :members,
        AuroraCGP.Projector.Membership.get_all_membership_by_uo(assigns.context)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="card w-4/6 flex flex-col h-fit justify-center items-center">
      <%= inspect(@filter) %>
      <div class="flex w-full h-12 flex-row">
        <div class="flex w-fit grow">
          <ul class="flex flex-row gap-3 items-center tabs">
            <li class={if @filter == "all", do: "active", else: ""}>
              <a phx-click="update_filter" phx-value-filter="all" phx-target={@myself}>Todos</a>
            </li>

            <li class={if @filter == "new", do: "active", else: ""}>
              <a phx-click="update_filter" phx-value-filter="new" phx-target={@myself}>Nuevos</a>
            </li>

            <li class={if @filter == "active", do: "active", else: ""}>
              <a phx-click="update_filter" phx-value-filter="active" phx-target={@myself}>Activos</a>
            </li>

            <li class={if @filter == "inactive", do: "active", else: ""}>
              <a phx-click="update_filter" phx-value-filter="inactive" phx-target={@myself}>
                Inactivos
              </a>
            </li>
          </ul>
        </div>

        <div class="flex w-fit">
          <button class="justify-center items-center text-lg primary">
            <FontAwesome.LiveView.icon name="hand" type="solid" class="h-5 w-5" /> Gobernar
          </button>
        </div>
      </div>
       <hr class="my-5" />
      <div class="relative overflow-x-auto">
        <table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
          <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
            <tr>
              <th scope="col" class="px-6 py-3">
                Nombre miembro
              </th>

              <th scope="col" class="px-6 py-3">
                Estado miembro
              </th>

              <th scope="col" class="px-6 py-3">
                Miembro desde
              </th>
            </tr>
          </thead>

          <tbody>
            <%= for m <- @members do %>
              <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
                <th
                  scope="row"
                  class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                >
                  <%= m.person.person_name %>
                </th>

                <td class="px-6 py-4">
                  <%= m.membership_status %>
                </td>

                <td class="px-6 py-4">
                  <%= m.created_at %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </section>
    """
  end

  def handle_event("update_filter", %{"filter" => filter}, socket) do
    IO.inspect(filter, label: "QQ")

    {:noreply, assign(socket, filter: filter)}
  end
end
