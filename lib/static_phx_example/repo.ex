defmodule StaticPhxExample.Repo do
  use Ecto.Repo,
    otp_app: :static_phx_example,
    adapter: Ecto.Adapters.Postgres
end
