defmodule Vega.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Vega.Repo,
      # Start the Telemetry supervisor
      VegaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Vega.PubSub},
      # Start the Endpoint (http/https)
      VegaWeb.Endpoint,
      Vega.PromEx
      # Start a worker by calling: Vega.Worker.start_link(arg)
      # {Vega.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vega.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VegaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
