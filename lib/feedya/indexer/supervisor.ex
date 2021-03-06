defmodule Feedya.Indexer.Supervisor do
  use Supervisor

  alias Feedya.{Repo, HN.Subscription}

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [worker(Feedya.Indexer.Worker, [])]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start!(sub_id) do
    Supervisor.start_child(__MODULE__, [sub_id])
  end

  def start_indexers! do
    for sub <- subscriptions, do: start!(sub.id)
  end

  defp subscriptions do
    Repo.all(Subscription)
  end
end
