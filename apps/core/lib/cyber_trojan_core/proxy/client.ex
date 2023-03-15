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
  def start({m, ip, port}) do
    {:ok, socket} = 
      :gen_tcp.listen(port, [:binary, packet: 0, active: false, reuseaddr: true])
    Logger.info("Accept connections on port #{port}")
    DynamicSupervisor.start_child()
  end
  
  def 
  
  @impl true
  def init(s) do
    :gen_tcp.accept(s)
    
  end
  
end
