defmodule GibonWeb.ConsoleLive do
  use GibonWeb, :live_view

  # Mount

  @impl true
  def mount(%{"port" => port}, _session, socket) do
    device = Gibon.Repo.get_by(Gibon.Serial.Device, port: port)
    {:ok, fetch(socket, device)}
  end

  # Render

  @impl true
  def render(assigns) do
    Phoenix.View.render(GibonWeb.ConsoleLiveView, "console_live.html", assigns)
  end

  # Fetch functions

  def fetch(socket) do
    socket
  end

  def fetch(socket, device) do
    fetch(socket)
    |> assign(device: device)
  end
end
