defmodule Swarm.Tracker.TrackerProxy do
  @moduledoc """
  Proxy module used in place of Swarm.Tracker
  """

  use GenServer
  alias Swarm.Tracker

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call({:call, call, timeout}, _from, state) do
    reply =
      case Tracker.active_nodes() do
        [] -> {:error, :no_active_nodes}
        nodes ->
          node = Enum.random(nodes)
          :rpc.call(node, GenStateMachine, :call, [Tracker, call, timeout])
      end
    {:reply, reply, state}
  end

end
