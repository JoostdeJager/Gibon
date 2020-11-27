defmodule GibonWeb.DevicesLive do
  use GibonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :update)
    {:ok, fetch(socket)}
  end

  @impl true
  def handle_event("add-device", %{"port" => port}, socket) do
    case device = Circuits.UART.enumerate() |> Map.get(port) do
      %{} ->
        Gibon.Serial.create_device(%{"port" => port, "product_id" => device.product_id})
    end

    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_event("delete-device", %{"port" => port}, socket) do
    Gibon.Repo.get_by(Gibon.Serial.Device, port: port) |> Gibon.Repo.delete()
    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_event("edit-conditions", %{"port" => port}, socket) do
    redirect socket, to: Routes.condition_path(socket, :index, port)
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
    assign(
      socket,
      circuits: Circuits.UART.enumerate(),
      devices: Gibon.Serial.list_devices,
      ports: GibonWeb.SerialHelper.get_ports(Gibon.Serial.list_devices)
    )
  end
end
