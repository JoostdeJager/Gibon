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

    # Subscribe
    GibonWeb.SerialHelper.subscribe()

    # Get the device and the conditions from the database
    device = Gibon.Repo.get_by(Gibon.Serial.Device, port: port) |> Gibon.Repo.preload(:conditions)

    # Return the initial state
    {:ok, %{"device" => device, "pid" => pid}}
  end

  # Receive the data
  def handle_info({:circuits_uart, _pid, message}, state) do
    conditions = state["device"].conditions
    for condition <- conditions do
      condition_string =
        case condition.type do
          "number" ->
            {parsed_message, _} = Integer.parse(message)
            {value, _} = Integer.parse(condition.value)
            "#{parsed_message} #{condition.operator} #{value}"
          _ ->
            "\"#{message}\" #{condition.operator} \"#{condition.value}\""
        end
      {output, _} = Code.eval_string(condition_string)
      IO.inspect("#{condition_string} => #{output}")
    end
    {:noreply, state}
  end

  # React to a broadcast
  def handle_info(_, state) do
    new_state = Map.put(state, "device", Gibon.Repo.get_by(Gibon.Serial.Device, port: state["device"].port) |> Gibon.Repo.preload(:conditions))
    {:noreply, new_state}
  end

  # Stop the server
  def terminate(_reason, state) do
    Circuits.UART.close(state["pid"])
    :normal
  end
end
