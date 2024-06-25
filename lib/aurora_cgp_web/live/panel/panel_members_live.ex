defmodule MembersPanelComponent do
  # In Phoenix apps, the line is typically: use MyAppWeb, :live_component
  use Phoenix.LiveComponent

  def update(assigns, socket) do

    socket =
      socket
      |> assign(:context, assigns.context)
      |> assign(:members, AuroraCGP.Projector.Membership.get_all_membership_by_uo(assigns.context))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="card w-4/6 flex flex-col h-fit justify-center items-center">
      <div class="flex w-full h-12 flex-row">
        <div class="flex w-fit grow">
          <ul class="flex flex-row gap-3 items-center tabs">
            <li>Todos</li>

            <li class="active">Nuevos</li>

            <li>Activos</li>

            <li>Inactivos</li>
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
end
