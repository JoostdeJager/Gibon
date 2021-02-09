defmodule GibonWeb.TerminalHelper do
	@topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Gibon.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(Gibon.PubSub, @topic, message)
  end

  def filter_lines(lines) do
		for line <- lines do
			if String.length(line["message"]) > 0 do
				line
			end
		end
  end

	def get_lines do
		pid = Process.whereis(GibonWeb.Terminal)
		lines = GenServer.call(pid, :get)
		filter_lines(lines)
	end

	def add_line(line) do
		pid = Process.whereis(GibonWeb.Terminal)
		if String.length(Map.get(line, "message")) > 0 do
			GenServer.cast(pid, {:add, line})
		end
	end

	def clear do
		pid = Process.whereis(GibonWeb.Terminal)
		GenServer.cast(pid, :clear)
	end
end