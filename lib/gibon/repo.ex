defmodule Gibon.Repo do
  use Ecto.Repo,
    otp_app: :gibon,
    adapter: Ecto.Adapters.Postgres
end
