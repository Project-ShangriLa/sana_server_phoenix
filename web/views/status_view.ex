defmodule SanaServerPhoenix.StatusView do
  use SanaServerPhoenix.Web, :view

  def render("index.json", %{msg: msg}) do
   %{msg: msg}
  end
end
