defmodule Feedya do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Feedya.Repo, []),
      supervisor(Feedya.Endpoint, []),
      supervisor(Feedya.Crawler.Supervisor, []),
      supervisor(Feedya.Indexer.Supervisor, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Feedya.Supervisor]
    main_supervisor = Supervisor.start_link(children, opts)

    Feedya.Crawler.Supervisor.start_crawlers!
    Feedya.Indexer.Supervisor.start_indexers!
    main_supervisor
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Feedya.Endpoint.config_change(changed, removed)
    :ok
  end
end
