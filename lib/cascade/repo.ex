defmodule Cascade.Repo do
  use AshPostgres.Repo,
    otp_app: :cascade,
    adapter: Ecto.Adapters.Postgres
    
    def installed_extensions do
      ["uuid-ossp", "citext"]
    end
end
