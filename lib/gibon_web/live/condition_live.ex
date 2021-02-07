defmodule GibonWeb.ConditionLive do
  use GibonWeb, :live_view

  @impl true
  def mount(%{"port" => port}, _session, socket) do
    device = Gibon.Repo.get_by(Gibon.Serial.Device, port: port)
    {:ok, fetch(socket, device)}
  end

  @impl true
  def handle_event(
        "new-condition",
        %{"operator" => operator, "value" => value, "type" => type, "url" => url},
        socket
      ) do
    device = socket.assigns.device

    changeset =
      device
      |> Ecto.build_assoc(:conditions)
      |> Gibon.Serial.Condition.changeset(%{
        "operator" => operator,
        "value" => value,
        "url" => url,
        "type" => type
      })

    Gibon.Repo.insert(changeset)

    GibonWeb.SerialHelper.broadcast(:added)

    {:noreply, fetch(socket, :db)}
  end

  @impl true
  def handle_event("delete-condition", %{"id" => id}, socket) do
    Gibon.Repo.get(Gibon.Serial.Condition, id) |> Gibon.Repo.delete()

    GibonWeb.SerialHelper.broadcast(:deleted)

    {:noreply, fetch(socket, :db)}
  end

  @impl true
  def handle_event("start-listening", _, socket) do
    GibonWeb.SerialHelper.start_server(socket.assigns.device.port)
    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_event("stop-listening", _, socket) do
    GibonWeb.SerialListener.stop(Process.whereis(:"#{socket.assigns.device.port}"))
    {:noreply, fetch(socket)}
  end

  def fetch(socket, :db) do
    socket
    |> assign(
      device:
        Gibon.Repo.get_by(Gibon.Serial.Device, port: socket.assigns.device.port)
        |> Gibon.Repo.preload(:conditions)
    )
    |> fetch
  end

  def fetch(socket, device) do
    socket
    |> assign(device: device)
    |> fetch(:db)
  end

  def fetch(socket) do
    socket
    |> assign(listening: Process.whereis(:"#{socket.assigns.device.port}"))
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(GibonWeb.ConditionLiveView, "condition_live.html", assigns)
  end
end
