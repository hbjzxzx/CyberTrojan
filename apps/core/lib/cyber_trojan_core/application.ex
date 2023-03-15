defmodule CyberTrojan.Core.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: CyberTrojanCore.Worker.start_link(arg)
      # {CyberTrojanCore.Worker, arg}
      {DynamicSupervisor, name: CyberTrojan.Core.DynamicSupervisor, strategy: :one_for_one},
      {DynamicSupervisor, name: CyberTrojan.Core.DynamicSupervisor.Listener, strategy: :one_for_one},
      {Supervisor, name: CyberTrojan.Core.Supervisor, strategy: :one_for_rest}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CyberTrojan.Core.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
