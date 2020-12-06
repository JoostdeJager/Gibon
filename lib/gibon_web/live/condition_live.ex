defmodule GibonWeb.ConditionLive do
  use GibonWeb, :live_view

  @impl true
  def mount(%{"port" => port}, _session, socket) do
    device = Gibon.Repo.get_by(Gibon.Serial.Device, port: port)
    {:ok, fetch(socket, device)}
  end

  @impl true
  def handle_event("new-condition", %{"operator" => operator, "value" => raw_value, "type" => type, "url" => url} = params, socket) do
    IO.inspect(params)

    value =
      case type do
        "number" ->
          raw_value
        "text" ->
          "\"#{raw_value}\""
      end

    condition = %{operator: operator, value: value, url: url}
    IO.inspect condition

    device = socket.assigns.device
    changeset =
      device
      |> Ecto.build_assoc(:conditions)
      |> Gibon.Serial.Condition.changeset(condition)

    IO.inspect Gibon.Repo.insert(changeset)

    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_event("delete-condition", %{"value" => value}, socket) do
    Gibon.Repo.get_by(Gibon.Serial.Condition, value: value) |> Gibon.Repo.delete()
    {:noreply, fetch(socket)}
  end

  def fetch(socket, device) do
    socket
    |> assign(device: device)
    |> fetch
  end

  def fetch(socket) do
    assign(
      socket,
      device: Gibon.Repo.get_by(Gibon.Serial.Device, port: socket.assigns.device.port) |> Gibon.Repo.preload(:conditions)
    )
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(GibonWeb.ConditionLiveView, "condition_live.html", assigns)
  end
end
