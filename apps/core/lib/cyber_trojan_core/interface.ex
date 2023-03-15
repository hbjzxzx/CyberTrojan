defmodule CyberTrojan.Core.Types do
  defmacro __using__(_opts) do
    quote do
      @type socket_addr() :: :inet.socket_address() 
      @type gsocket() :: :inet.socket()
      @type bytes_cnt :: Integer.t()
      @type tunnel_id() :: String.t()
      @type tunnel() :: {Enumerable.t(), Collectable.t(), id :: String.t(), [String.t()]}
    end
  end
end

defmodule CyberTrojan.Core.Interface.TunnelClient do
  use CyberTrojan.Core.Types
  
  # api
  @callback start_link(init :: any()) :: {:ok, pid()} | {:error, String.t()}
  @callback establish_tunnel( dst :: socket_addr()) :: {:ok, tunnel()} | {:error, String.t()} 
  @callback close_tunnel(tunnel_id()) :: {:ok} | {:error, String.t()}

  # bounary  
  @callback start_link(init :: any()) :: any()

  # Core part
  @callback on_establish_tunnel(states :: any(), dst :: socket_addr()) :: {:ok, tunnel(), state :: any()} | {:error, String.t()}
  @callback on_close_tunnel(states :: any(), tid :: tunnel_id()) :: {:ok, state :: any()}  | {:error, String.t()} 
  @callback on_next_tunnel(states :: any(), dst :: socket_addr()) :: {:ok, next_client :: any()} | {:error, String.t()}
end

defmodule CyberTrojan.Core.Interface.TunnelServer do
  use CyberTrojan.Core.Types
  
  # api
  @callback start_link( init :: any()) :: {:ok, pid()} | {:error, String.t()}
  @callback accept_establish(t :: tunnel(), src :: socket_addr(), dst :: socket_addr()) :: {:ok} | {:error, String.t()}
  @callback close_tunnel(tid :: tunnel_id()) :: {:ok} | {:error, String.t()}
  
  # core
  @callback on_establish(states :: any(), tunnel(), src :: socket_addr(), dst :: socket_addr()) :: {:ok, state :: any} | {:error, String.t()}
  @callback on_close_tunnel(state :: any(), tid :: tunnel_id()) ::  {:ok, state :: any} | {:error, String.t()}
  @callback on_next_server(state :: any(), tunnel(), src :: socket_addr(), dst :: socket_addr()) :: {:ok, next_server :: any()} | {:error, String.t()}
end

defmodule CyberTrojan.Core.Interface.Proxyer.Client do
  use CyberTrojan.Core.Types
  # api
  @callback start_link( init :: any()) :: any()
  
  # core
  @callback accpet(state :: any(), s :: gsocket()) :: {:ok, tunnel()} | {:error, String.t()}
  @callback get_tunnel(state :: any(), dst :: socket_addr()) :: {:ok, tunnel()} | {:error, String.t()}
  @callback start_proxy(t1 :: tunnel(), t2 :: tunnel()) :: {:ok}
end

defmodule CyberTrojan.Core.Interface.Proxyer.IServer do
  use CyberTrojan.Core.Types
  
  # api
  @callback start_link( init :: any()) :: any()
  
  # core
  @callback accpet(state :: any(), s :: gsocket()) :: {:ok, tunnel()} | {:error, String.t()}
  @callback get_tunnel(state :: any(), t :: tunnel(), src :: socket_addr(), dst :: socket_addr()) :: {:ok, tunnel()} | {:error, String.t()}
  @callback start_proxy(t1 :: tunnel(), t2 :: tunnel()) :: {:ok}
end
