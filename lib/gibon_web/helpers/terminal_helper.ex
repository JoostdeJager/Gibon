defmodule GibonWeb.TerminalHelper do
	@topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(Gibon.PubSub, @topic)
  end

  def broadcast(message) do
    Phoenix.PubSub.broadcast(Gibon.PubSub, @topic, message)
  end

	def get_lines do
		pid = Process.whereis(GibonWeb.Terminal)
		GenServer.call(pid, :get)
	end

	def add_line(line) do
		pid = Process.whereis(GibonWeb.Terminal)
		GenServer.cast(pid, {:add, line})
	end

	def clear do
		pid = Process.whereis(GibonWeb.Terminal)
		GenServer.cast(pid, :clear)
	end
end