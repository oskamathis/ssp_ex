defmodule SspExWeb.ApiController do
  use SspExWeb, :controller

  def execute(conn, %{"app_id" => app_id}) do
    render(conn, "api.json", app_id: app_id)
  end
end
