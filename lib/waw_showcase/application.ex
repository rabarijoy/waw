defmodule WawShowcase.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WawShowcaseWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:waw_showcase, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WawShowcase.PubSub},
      # Start a worker by calling: WawShowcase.Worker.start_link(arg)
      # {WawShowcase.Worker, arg},
      # Start to serve requests, typically the last entry
      WawShowcaseWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WawShowcase.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WawShowcaseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
