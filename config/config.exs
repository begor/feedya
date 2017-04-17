# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :feedya,
  ecto_repos: [Feedya.Repo]

config :feedya,
  email: System.get_env("FEEDYA_EMAIL")

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

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Feedya",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_KEY"),
  serializer: Feedya.GuardianSerializer

config :feedya, Feedya.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.yandex.ru",
  port: 465,
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :if_available, # can be `:always` or `:never`
  ssl: true, # can be `true`
  retries: 3

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
