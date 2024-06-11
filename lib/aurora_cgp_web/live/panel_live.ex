defmodule AuroraCGPWeb.PanelLive do
  use AuroraCGPWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:ou_tree, AuroraCGP.Projector.OU.get_all_ou())

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      case params["context"] do
        nil ->
          push_patch(socket, to: "/panel/?context=#{Enum.at(socket.assigns.ou_tree, 0).ou_id}")

        context when is_bitstring(context) ->
          ou = Enum.find(socket.assigns.ou_tree, nil, fn ou -> ou.ou_id == context end)

          if ou != nil do
            assign(socket, context: ou)
          else
            socket
            |> put_flash(:error, "No se encontró la unidad organizacional")
            |> push_patch(to: "/panel/?context=#{Enum.at(socket.assigns.ou_tree, 0).ou_id}")
          end
      end

    {:noreply, socket}
  end

  defp update_ou_tree() do
    {:ok, %{ou_tree: AuroraCGP.Projector.OU.get_all_active_ou()}}
  end
end
