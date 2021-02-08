defmodule GibonWeb.SerialHelper do
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Gibon.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(Gibon.PubSub, @topic, message)
  end

  def get_ports(devices) do
    for device <- devices do
      device.port
    end
  end

  def filter_devices(devices) do
    [return | _] =
      for {key, value} <- devices do
        if Map.get(value, :product_id) == nil do
          Map.delete(devices, key)
        end
      end

    return
  end

  def start_server(port) do
    pid = Process.whereis(GibonWeb.SerialManager)
    GenServer.cast(pid, {:new, port})
  end

  def stop_server(port) do
    pid = Process.whereis(GibonWeb.SerialManager)
    GenServer.cast(pid, {:close, port})
  end

  def is_running(port) do
    pid = Process.whereis(GibonWeb.SerialManager)
    GenServer.call(pid, {:running, port})
  end
end
