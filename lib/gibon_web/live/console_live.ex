defmodule GibonWeb.ConsoleLive do
  use GibonWeb, :live_view

  # Mount

  @impl true
  def mount(%{"port" => port}, _session, socket) do
    device = Gibon.Repo.get_by(Gibon.Serial.Device, port: port)
    GibonWeb.SerialHelper.start_console(port)
    GibonWeb.SerialManager.subscribe()

    GibonWeb.TerminalHelper.clear()
    GibonWeb.TerminalHelper.subscribe()
    {:ok, fetch(socket, device)}
  end

  # Render

  @impl true
  def render(assigns) do
    Phoenix.View.render(GibonWeb.ConsoleLiveView, "console_live.html", assigns)
  end

  # Send message

  @impl true
  def handle_event("send-message", %{"message" => message}, socket) do
    if String.length(message) > 0 do
      GibonWeb.SerialHelper.send_message(socket.assigns.device.port, message)
    end
    {:noreply, push_event(fetch(socket, :clear), "add", %{})}
  end

  @impl true
  def handle_event("clear", _data, socket) do
    GibonWeb.TerminalHelper.clear()
    {:noreply, fetch(socket)}
  end

  # Pubsub

  def handle_info("stopped", socket) do
    {:noreply, push_redirect(socket, to: Routes.condition_path(socket, :index, socket.assigns.device.port))} 
  end

  def handle_info(_, socket) do
    {:noreply, fetch(socket)}
  end

  # On close

  @impl true
  def terminate(_reason, socket) do
    if GibonWeb.SerialHelper.is_running(socket.assigns.device.port) do
      GibonWeb.SerialHelper.stop_server(socket.assigns.device.port)
    end
    :normal
  end

  # Fetch functions

  def fetch(socket) do
    socket
    |> assign(lines: GibonWeb.TerminalHelper.get_lines())
  end

  def fetch(socket, :clear) do
    fetch(socket)
    |> assign(message: "")
  end

  def fetch(socket, device) do
    fetch(socket)
    |> assign(message: "")
    |> assign(device: device)
  end
end
