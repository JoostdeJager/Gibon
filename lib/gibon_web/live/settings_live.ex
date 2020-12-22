defmodule GibonWeb.SettingsLive do
  use GibonWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(GibonWeb.SettingsLiveView, "settings_live.html", assigns)
  end

  def fetch(socket) do
    socket
  end
end
