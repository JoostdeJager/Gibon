defmodule GibonWeb.Terminal do
	use GenServer

	def start_link(_params) do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def init(state) do
		{:ok, state}
	end
	
	def handle_cast({:add, line}, state) do
		GibonWeb.TerminalHelper.broadcast("add")
		{:noreply, [line | state]}
	end

	def handle_cast(:clear, _state) do
		GibonWeb.TerminalHelper.broadcast("clear")
		{:noreply, []}
	end

	def handle_call(:get, _from, state) do
		{:reply, state, state}
	end
end