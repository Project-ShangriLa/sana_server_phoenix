defmodule SanaServerPhoenix.PageController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
