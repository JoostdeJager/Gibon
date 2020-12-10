defmodule GibonWeb.DevicesLive do
  use GibonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(500, self(), :update)
    {:ok, fetch(:db, socket)}
  end

  @impl true
  def handle_event("add-device", %{"port" => port}, socket) do
    case device = Circuits.UART.enumerate() |> Map.get(port) do
      %{} ->
        Gibon.Serial.create_device(%{"port" => port, "product_id" => device.product_id, "listening" => false})
    end

    {:noreply, fetch(:db, socket)}
  end

  @impl true
  def handle_event("delete-device", %{"port" => port}, socket) do
    Gibon.Repo.get_by(Gibon.Serial.Device, port: port) |> Gibon.Repo.delete()
    {:noreply, fetch(:db, socket)}
  end

  @impl true
  def handle_event("start-listening", %{"port" => port}, socket) do
    device = Gibon.Repo.get_by(Gibon.Serial.Device, port: port) |> Gibon.Repo.preload(:conditions)
    IO.inspect(device)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, fetch(socket)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(GibonWeb.DevicesLiveView, "devices_live.html", assigns)
  end

  def fetch(socket) do
    socket
    |> assign(circuits: Circuits.UART.enumerate())
  end

  def fetch(:db, socket) do
    fetch(socket)
    |> assign(devices: Gibon.Serial.list_devices)
    |> assign(ports: GibonWeb.SerialHelper.get_ports(Gibon.Serial.list_devices))
  end
end
