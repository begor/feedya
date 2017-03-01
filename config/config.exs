# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :feedya,
  ecto_repos: [Feedya.Repo]

# Configures the endpoint
config :feedya, Feedya.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pOIp9br2PYNkzxfl2PD9Gsn05t4VAs0d2wYsBfCWAAjAMdOaoc60AzZmC0YRqoTB",
  render_errors: [view: Feedya.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Feedya.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
