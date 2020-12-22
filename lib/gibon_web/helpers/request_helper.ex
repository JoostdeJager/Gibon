defmodule GibonWeb.RequestHelper do
  def send_request(url) do
    HTTPoison.get(url)
  end
end
