defmodule SanaServerPhoenix.TwitterFollwerHistoryView do
  use SanaServerPhoenix.Web, :view

  def render("index.json", %{msg: msg}) do
   msg
  end

end
