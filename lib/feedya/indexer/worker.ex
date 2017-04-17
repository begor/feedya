# NOTE: just a high-level concept, still very much WIP
defmodule Feedya.Indexer.Worker do
  use GenServer

  alias Feedya.HN.Subscription

  @period 30 * 1000

  def start_link(sub_id, opts \\ []) do
    GenServer.start_link(__MODULE__, sub_id, opts)
  end

  def init(sub_id) do
    schedule_work
    {:ok, sub_id}
  end

  def handle_info(:index, sub_id) do
    Subscription.index!(sub_id)
    schedule_work
    {:noreply, sub_id}
  end

  defp schedule_work do
    Process.send_after(self(), :index, @period)
  end
end
