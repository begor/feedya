defmodule Feedya.Crawler.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [worker(Feedya.Crawler.Worker, [])]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_crawlers! do
    for crawler_func <- crawlers, do: Supervisor.start_child(__MODULE__, [crawler_func])
  end

  defp crawlers do
    [&Feedya.HN.Story.save_top!/0,
     &Feedya.HN.Story.save_new!/0,
     &Feedya.HN.Story.save_best!/0]
  end
end
