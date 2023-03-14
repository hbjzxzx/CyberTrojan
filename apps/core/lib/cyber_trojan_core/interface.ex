defmodule CyberTrojan.Core.Types do
  defmacro __using__(_opts) do
    quote do
      @type socket_addr() :: :inet.socket_address() 
      @type gsocket() :: :inet.socket()
      @type bytes_cnt :: Integer.t()
    end
  end
end

defmodule CyberTrojan.Core.Topology do
  use CyberTrojan.Core.Types
  
  @type router_predict :: (src :: socket_addr(), dst :: socket_addr() -> Bool.t())

  # boundary part
  @callback start_link(args :: any()) :: any()

  @callback next(self :: identifier(), item :: String.t()) :: {:ok, next_item :: String.t()} | nil
  
  @callback link(self :: identifier(), from :: String.t(), to :: String.t(), pred :: router_predict()) :: {:ok} | {:error, String.t()}
  
  # Core part
  @callback get_next(item :: String.t(), state) :: {:ok, next_item :: String.t()} | nil
  
  @callback reigster_link(from :: String.t(), to :: String.t(), condition :: router_predict(),  state :: any()) :: {:ok, new_state :: any()} | {:error, String.t()}
    
end

defmodule CyberTrojan.Core.Endpoint.In do
  use CyberTrojan.Core.Types
  
  @callback start_link(socket_addr() | :no_bind, port()) :: {:ok, pid()} | {:error, String.t()}

  @callback register_forward(any(), String.t(), identifier(), (src :: socket_addr(), dst:: socket_addr() -> Bool.t())) :: {:ok} | {:error, String.t()}
  
  @callback register_proxy(any(), String.t(), identifier()) :: {:ok} | {:error, String.t()}

  @callback forward_socket(any(), socket :: gsocket(), src :: socket_addr(), dst :: socket_addr()) :: {:ok} | {:error, String.t()}
  
  
  @optional_callbacks run: 1
  # Core part
  @callback proxy_stream(raw_stream :: Enumerable.t(), src :: socket_addr(), dst :: socket_addr()) :: out 


end

defmodule CyberTrojan.Core.Endpoint.Out do
  use CyberTrojan.Core.Types
  
  @callback start_link(any()) :: {:ok, pid()} | {:error, String.t()}

  @callback proxy(any(), gsocket(), src :: socket_addr(), dst :: socket_addr()) :: {:ok} | {:error, String.t()}
end

