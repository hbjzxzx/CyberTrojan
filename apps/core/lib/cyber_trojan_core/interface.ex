defmodule CyberTrojan.Core.Types do
  defmacro __using__(_opts) do
    quote do
      @type socket_addr() :: :inet.socket_address() 
      @type gsocket() :: :inet.socket()
      @type bytes_cnt :: Integer.t()
    end
  end
end

defmodule CyberTrojan.Core.Endpoint.In do
  use CyberTrojan.Core.Types
  
  @callback start_link(socket_addr() | :no_bind, port()) :: {:ok, pid()} | {:error, String.t()}

  @callback register_forward(any(), String.t(), identifier(), (src :: socket_addr(), dst:: socket_addr() -> Bool.t())) :: {:ok} | {:error, String.t()}
  
  @callback register_proxy(any(), String.t(), identifier()) :: {:ok} | {:error, String.t()}

  @callback forward_socket(any(), socket :: gsocket(), src :: socket_addr(), dst :: socket_addr()) :: {:ok} | {:error, String.t()}
  
  @callback run(any()) :: {:ok} | {:error, String.t()}
  
  @optional_callbacks run: 1
end

defmodule CyberTrojan.Core.Endpoint.Out do
  use CyberTrojan.Core.Types
  
  @callback start_link(any()) :: {:ok, pid()} | {:error, String.t()}

  @callback proxy(any(), gsocket(), src :: socket_addr(), dst :: socket_addr()) :: {:ok} | {:error, String.t()}
end

