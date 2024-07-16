defmodule AuroraCGPWeb.PanelLive do
  use AuroraCGPWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:ou_tree, AuroraCGP.Projector.OU.get_all_ou())

    {:ok, socket}
  end

  def handle_params(params, uri, socket) do
    socket =
      socket
      |> assign(:context, parse_context(params, socket))
      |> assign(:module, extract_module_from_uri(uri))
      |> assign(:show_ou_select, parse_ou_select(params))
      |> assign(:uri, uri)

    # IO.inspect(socket)

    # socket =
    #   case params["context"] do
    #     nil ->
    #       push_patch(socket, to: "/panel/?context=#{Enum.at(socket.assigns.ou_tree, 0).ou_id}")

    #     context when is_bitstring(context) ->
    #       ou = Enum.find(socket.assigns.ou_tree, nil, fn ou -> ou.ou_id == context end)

    #       if ou != nil do
    #         assign(socket, context: ou)
    #       else
    #         socket
    #         |> put_flash(:error, "No se encontró la unidad organizacional")
    #         |> push_patch(to: "/panel/?context=#{Enum.at(socket.assigns.ou_tree, 0).ou_id}")
    #       end
    #   end

    #   socket =
    #     case params["module"] do
    #       nil ->
    #         push_patch(socket, to: "/panel/?module=inicio")

    #       module when is_bitstring(module) ->

    #         socket
    #         assign(socket, module: module)
    #         |> push_patch(to: "/panel/?context=")

    #         end
    #     end

    {:noreply, socket}
  end

  # defp update_ou_tree() do
  #   {:ok, %{ou_tree: AuroraCGP.Projector.OU.get_all_active_ou()}}
  # end

  defp parse_ou_select(params) do
    case params["show-tree"] do
      "true" ->
        true

      _ ->
        false
    end
  end

  defp parse_context(params, socket) do
    case params["context"] do
      context when is_bitstring(context) ->
        context

      _ ->
        get_default_context(socket)
    end
  end

  defp get_default_context(socket) do
    default = Enum.at(socket.assigns.ou_tree, 0).ou_id

    case default do
      default when is_bitstring(default) ->
        default

      _ ->
        IO.inspect("Error")
    end
  end

  defp extract_module_from_uri(uri) do
    module = Enum.at(String.split(Enum.at(String.split(uri, "/"), -1), "?"), 0)

    case module do
      "panel" ->
        "inicio"

      "" ->
        "inicio"

      _ ->
        module
    end
  end
end
