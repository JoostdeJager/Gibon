defmodule GibonWeb.RequestHelper do
  def send_request(url) do
  	try do
	  HTTPoison.get(url)
	rescue
	  _ ->
	  	IO.puts "Whoops"
	end
  end
end
