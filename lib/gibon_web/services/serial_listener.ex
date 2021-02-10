defmodule GibonWeb.SerialListener do
  use GenServer

  # Client

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  # Server

  def start_link({port, _check_conditions} = options) do
    GenServer.start_link(__MODULE__, options, name: :"#{port}")
  end

  def init({port, check_conditions}) do
    # Open the Serial port
    {:ok, pid} = Circuits.UART.start_link()

    Circuits.UART.configure(pid, framing: {Circuits.UART.Framing.Line, separator: "\r\n"})
    Circuits.UART.open(pid, port)

    # Subscribe
    GibonWeb.SerialHelper.subscribe()

    # Get the device and the conditions from the database
    device = Gibon.Repo.get_by(Gibon.Serial.Device, port: port) |> Gibon.Repo.preload(:conditions)

    # Return the initial state
    {:ok, %{"device" => device, "pid" => pid, "check_conditions" => check_conditions}}
  end

  def handle_cast({:send, message}, state) do
    pid = state["pid"]
    response = Circuits.UART.write(pid, message)

    IO.puts "++++++++++++++++"
    IO.puts "+ Message sent +"
    IO.puts "++++++++++++++++"

    GibonWeb.TerminalHelper.add_line(%{"message" => message, "sender" => "user"})
    {:noreply, state}
  end

  # Receive the data
  def handle_info({:circuits_uart, _pid, message}, state) do
    case state["check_conditions"] do
      true ->
        GibonWeb.SerialHelper.check_conditions(state, message)
      _ ->
        GibonWeb.TerminalHelper.add_line(%{"message" => message, "sender" => "serial"})
    end

    {:noreply, state}
  end

  # React to a broadcast
  def handle_info(_, state) do
    new_state =
      Map.put(
        state,
        "device",
        Gibon.Repo.get_by(Gibon.Serial.Device, port: state["device"].port)
        |> Gibon.Repo.preload(:conditions)
      )

    {:noreply, new_state}
  end

  # Stop the server
  def terminate(_reason, state) do
    Circuits.UART.close(state["pid"])
    :normal
  end
end
