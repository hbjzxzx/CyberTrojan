defmodule CyberTrojan.Core.Proxyer.Client do
  @behaviour CyberTrojan.Core.Interface.Proxyer.Client
  use GenServer 
  
  # api
  def start_link({ip, port}) do
    GenServer.start_link(__MODULE__, {ip, port})
  end
  
  # bounary
  def init({ip, port}) do 
    # {:ok, socket} = :gen_tcp.listen(port, [binary, {}])  
    {:ok, {}} 
  end
  
end

defmodule CyberTrojan.Core.Proxyer.Listener do
  use GenServer
  require Logger
  def start_link({m, ip, port}) do
    GenServer.start_link(__MODULE__, {m, ip, port}, name: CyberTrojan.Core.Proxyer.Listener)
  end
  
  @impl true
  def init({cnt, ip, port}) do
    {:ok, socket} = 
      :gen_tcp.listen(port, [:binary, packet: 0, active: false, reuseaddr: true])
    Logger.info("Starting Listening on #{ip}:#{port}")
    Logger.info("Creating #{cnt} Acceptors...")
    1..cnt
    |> Enum.map(fn n -> Task.Supervisor.start_child(CyberTrojan.Core.Proxyer.Acceptor,
                                                  fn -> accept(n, socket) end, 
                                                  restart: :transient
                                                  ) end)
    Logger.info("Creating #{cnt} Acceptors done")
    {:ok, {socket}}
  end
  
  #core 
  def accept(n, socket) do
    Logger.info("Listener worker: #{n} waiting for connect...")
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info("Listener worker: #{n} accept an connect")
    accept(n, socket)
  end
end


defmodule CyberTrojan.Core.Proxyer.Supervisor do
  use Supervisor
  
  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end
  
  def init(:ok) do
    children = [
      {Task.Supervisor, name: CyberTrojan.Core.Proxyer.Acceptor, strategy: :one_for_one},
      {DynamicSupervisor, name: CyberTrojan.Core.Proxyer.Worker, strategy: :one_for_one},
      {CyberTrojan.Core.Proxyer.Listener, {2, "127.0.0.1", 1081}},
    ]
    opts = [strategy: :one_for_one, name: CyberTrojan.Core.Proxyer.Supervisor]
    Supervisor.init(children, opts)
  end
end