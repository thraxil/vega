defmodule Vega.Repo do
  use Ecto.Repo,
    otp_app: :vega,
    adapter: Ecto.Adapters.Postgres
end
