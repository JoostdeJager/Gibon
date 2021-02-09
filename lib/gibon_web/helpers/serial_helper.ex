defmodule GibonWeb.SerialHelper do

  # Pubsub

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Gibon.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(Gibon.PubSub, @topic, message)
  end

  # Helper functions

  def get_ports(devices) do
    for device <- devices do
      device.port
    end
  end

  def filter_devices(devices) do
    response =
      for {key, value} <- devices do
        if Map.get(value, :product_id) == nil do
          Map.delete(devices, key)
        end
      end
    [return] = Enum.filter(response, & !is_nil(&1)) 
    return
  end

  def get_condition_string(condition, message) do
    case condition.type do
      "number" ->
        case Float.parse(message) do
          {parsed_message, _} ->
            {value, _} = Float.parse(condition.value)
            "#{parsed_message} #{condition.operator} #{value}"
          _ ->
            ""
        end
      _ ->
        "\"#{message}\" #{condition.operator} \"#{condition.value}\""
    end
  end

  def get_condition_url(condition, message) do
    case String.ends_with?(condition.url, "/") do
      true ->
        "#{condition.url}#{message}"
      _ ->
        "#{condition.url}/#{message}"
    end
  end

  def perform_condition(condition, condition_string, message) do
    case Code.eval_string(condition_string) do
      {true, _} ->
        url = get_condition_url(condition, message)
        GibonWeb.RequestHelper.send_request(url)
      _ ->
        false
    end
  end

  def check_conditions(state, message) do
    conditions = state["device"].conditions

    for condition <- conditions do
      condition_string = get_condition_string(condition, message)
      perform_condition(condition, condition_string, message)
    end
  end

  # Genserver manager

  def start_server(port) do
    pid = Process.whereis(GibonWeb.SerialManager)
    GenServer.cast(pid, {:new, {port, true}})
  end

  def start_console(port) do
    pid = Process.whereis(GibonWeb.SerialManager)
    GenServer.cast(pid, {:new, {port, false}})
  end

  def send_message(port, message) do
    pid = Process.whereis(GibonWeb.SerialManager)
    GenServer.cast(pid, {:send, port, message})
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
