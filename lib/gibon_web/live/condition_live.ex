defmodule GibonWeb.ConditionLive do
  use GibonWeb, :live_view

  @impl true
  def mount(%{"port" => port}, _session, socket) do
    IO.inspect(port)
    {:ok, socket}
  end

  def fetch(socket) do
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(GibonWeb.ConditionLiveView, "condition_live.html", assigns)
  end
end
