defmodule GibonWeb.RequestHelper do
  def send_request(url, port) do
  	try do
	  case HTTPoison.get(url) do
	  	{:error, _} ->
	  		nil

	  	{:ok, %HTTPoison.Response{:body => body}} ->
	  		case Poison.decode(body) do
	  			{:ok, json} -> 
	  				if Map.has_key?(json, "message") do
	  					GibonWeb.SerialHelper.send_message(port, Map.get(json, "message"))
	  				end
	  		end
	  end
	rescue
	  _ ->
	  	IO.puts "Whoops"
	end
  end
end
