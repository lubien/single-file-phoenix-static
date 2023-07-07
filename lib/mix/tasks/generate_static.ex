defmodule Mix.Tasks.GenerateStatic do
  @moduledoc "Generate a static file for Phoenix app"
  use Mix.Task

  @endpoint StaticPhxExampleWeb.Endpoint
  use StaticPhxExampleWeb, :verified_routes
  use StaticPhxExampleWeb, :html
  import Phoenix.ConnTest

  @shortdoc "Generates index.html file for each route defined below"
  def run(_) do
    Mix.Task.run("phx.server")

    [
      ~p"/",
      ~p"/other"
    ]
    |> Enum.each(&generate_html_for_route/1)

    exit(:normal)
  end

  def generate_html_for_route(route_path) do
    conn = Phoenix.ConnTest.build_conn()
    conn = get(conn, route_path)
    resp = html_response(conn, 200)

    app_name = Keyword.fetch!(Mix.Project.get().project(), :app)

    priv_static_path = Path.join([:code.priv_dir(app_name), "static", route_path])

    :ok = File.mkdir_p(priv_static_path)

    priv_static_filepath = Path.join([priv_static_path, "index.html"])

    {:ok, file} = File.open(priv_static_filepath, [:write])
    :ok = IO.binwrite(file, resp)
    File.close(file)
  end
end
