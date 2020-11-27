defmodule GibonWeb.SerialHelper do
  def get_ports(devices) do
    for device <- devices do
      device.port
    end
  end
end
