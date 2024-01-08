import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :cascade, Cascade.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "cascade_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cascade, CascadeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "EX1amfSuyG3kPe2VC7E/gh+Lw+SkqvY61J7KQPQb+2iHl5p5ADM6hnBoxDPV6ANb",
  server: false

# In test we don't send emails.
config :cascade, Cascade.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
