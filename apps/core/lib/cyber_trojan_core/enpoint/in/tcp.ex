defmodule CyberTrojan.Core.Endpoint.In.Tcp do
  require Logger
  use GenServer
  @behaviour CyberTrojan.Core.Endpoint.In
  
  # server side
  def init({ip, port}) do
    {:ok, listen_socket} = 
      :gen_tcp.listen(port, [:binary, 
        packet: 0, 
        active: false, 
        reuseaddr: true,
        ip: ip])
      Logger.info("Accept connections on port #{port}")
    {:ok, {listen_socket, %{}}}
  end
  
  # stat to listening
  def handle_call(:run, _from, {listen_socket, _}) do
    {:ok, client} = :gen_tcp.accept(socket)
  end
  
  
  # client side
  def start_link({addr, port}, opts \\ [])  do 
    DynamicSupervisor.start_child(
      CyberTrojan.Core.Endpoint.DynamicSupervisor,
      {__MODULE__, [{addr, port}, opts]}
    )
  end

  def run(self) do  
    GenServer.call(self, :run)
  end

  def register_forward(self, name, next, predictor) do
    GenServer.call(self, {:register_next, name, next, predictor})
  end
  
  def register_proxy(self, name, next) do 
    GenServer.call(self, {:register_proxy, name, next})
  end

  def forward_socket(self, socket, src, dst) do
    GenServer.call(self, {:forward, socket, src, dst})
  end
  
  
end
