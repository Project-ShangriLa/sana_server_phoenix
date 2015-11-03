defmodule SanaServerPhoenix.StatusController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, msg: "hogehoge"
  end

end
