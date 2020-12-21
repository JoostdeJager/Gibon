defmodule GibonWeb.SerialHelper do
  def get_ports(devices) do
    for device <- devices do
      device.port
    end
  end

  def start_server(port) do
    GibonWeb.SerialListener.start_link(port)
  end
end
