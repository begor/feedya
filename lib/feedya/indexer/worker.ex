# NOTE: just a high-level concept, still very much WIP
defmodule Feedya.Indexer.Worker do
  use GenServer

  @period 30 * 1000

  def start_link(subscription, opts \\ []) do
    GenServer.start_link(__MODULE__, subscription, opts)
  end

  def init(subscription) do
    schedule_work
    {:ok, subscription}
  end

  def handle_info(:index, subscription) do
    Feedya.HNSubscription.index!(subscription)
    schedule_work
    {:noreply, subscription}
  end

  defp schedule_work do
    Process.send_after(self(), :index, @period)
  end
end
