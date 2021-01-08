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
    [return | _] = for {key, value} <- devices do
      if value == %{} do
        Map.delete(devices, key)
      end
    end
    return
  end

  def get_code_string(condition, message) do
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

  def start_server(port) do
    GibonWeb.SerialListener.start_link(port)
  end
end
