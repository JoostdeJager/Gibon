defmodule GibonWeb.SerialListener do
  use GenServer

  # Client

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  # Server

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: :"#{port}")
  end

  def init(port) do
    # Open the Serial port
    {:ok, pid} = Circuits.UART.start_link
    Circuits.UART.configure(pid, framing: {Circuits.UART.Framing.Line, separator: "\r\n"})
    Circuits.UART.open(pid, port)

    # Get the device and the conditions from the database
    device = Gibon.Repo.get_by(Gibon.Serial.Device, port: port) |> Gibon.Repo.preload(:conditions)
    Gibon.Serial.update_device(device, %{listening: true})

    # Return the initial state
    {:ok, %{"device" => device, "pid" => pid}}
  end

  # Receive the data
  def handle_info({:circuits_uart, _pid, message}, state) do
    # IO.inspect(state["device"].conditions)
    IO.inspect(message)
    {:noreply, state}
  end

  # Stop the server
  def terminate(_reason, state) do
    Circuits.UART.close(state["pid"])
    :normal
  end
end
