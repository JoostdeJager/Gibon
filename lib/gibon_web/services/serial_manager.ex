defmodule GibonWeb.SerialManager do
  use GenServer

  # PUBSUB

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Gibon.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(Gibon.PubSub, @topic, message)
  end

  # GENSERVER

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  def start_link(_params) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(servers) do
    IO.puts("+++++++++++++++++++++++++++++")
    IO.puts("+ SerialManager has started +")
    IO.puts("+++++++++++++++++++++++++++++")
    {:ok, servers}
  end

  def handle_cast({:new, port}, servers) do
    new_servers =
      case GibonWeb.SerialListener.start_link(port) do
        {:ok, pid} ->
          Map.put(servers, port, pid)
      end

    IO.puts("+++++++++++++++++++++++++++++++++++")
    IO.puts("+ SerialListener has been started +")
    IO.puts("+++++++++++++++++++++++++++++++++++")

    broadcast("SerialListener started")

    {:noreply, new_servers}
  end

  def handle_cast({:close, port}, servers) do
    new_servers =
      if Map.has_key?(servers, port) do
        GibonWeb.SerialListener.stop(Map.get(servers, port))
        Map.delete(servers, port)
      end

    IO.puts("+++++++++++++++++++++++++++++++++++")
    IO.puts("+ SerialListener has been stopped +")
    IO.puts("+++++++++++++++++++++++++++++++++++")

    broadcast("SerialListener stopped")

    {:noreply, new_servers}
  end

  def handle_call({:running, port}, _from, servers) do
    {:reply, Map.has_key?(servers, port), servers}
  end
end
