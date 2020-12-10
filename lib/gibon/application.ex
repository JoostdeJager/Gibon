defmodule Gibon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Gibon.Repo.update_all(Gibon.Serial.Device, set: [listening: false])

    children = [
      # Start the Ecto repository
      Gibon.Repo,
      # Start the Telemetry supervisor
      GibonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gibon.PubSub},
      # Start the Endpoint (http/https)
      GibonWeb.Endpoint
      # Start a worker by calling: Gibon.Worker.start_link(arg)
      # {Gibon.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gibon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GibonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
