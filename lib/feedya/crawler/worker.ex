# NOTE: just a high-level concept, still very much WIP
defmodule Feedya.Crawler.Worker do
  use GenServer

  @period 10 * 1000

  def start_link(func, opts \\ []) do
    GenServer.start_link(__MODULE__, func, opts)
  end

  def init(func) do
    schedule_work
    {:ok, func}
  end

  def handle_info(:work, func) do
    func.()
    schedule_work
    {:noreply, func}
  end

  defp schedule_work do
    Process.send_after(self(), :work, @period)
  end
end
