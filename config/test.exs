import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :prokeep, ProkeepWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "PcZjqQ4XGWENeALuEfBmuqRt1zuPEutw/RCHJzUuIZG4aLfJvOyjzlP1G1M6VEE5",
  server: false

# Print only warnings and errors during test
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
