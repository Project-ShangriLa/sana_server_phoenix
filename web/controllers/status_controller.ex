defmodule SanaServerPhoenix.StatusController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do

    #IDからTwitterのステートを取得
    #  {:ok, result} = Mariaex.Connection.query(p, "SELECT * FROM bases where twitter_account IN '#{_params["accounts"]}'")
    #  IO.inspect result
    # http://hexdocs.pm/ecto/Ecto.Adapters.SQL.html#query/4
    #パラメーターを受け取る _params["accounts"]

    account_list = Enum.join(String.split(_params["accounts"],","), "\",\"")
    account_list_st = "\"" <> account_list <> "\""

    #Baseテーブルを検索しIDを取得
    {:ok, result } = Ecto.Adapters.SQL.query(Repo, "SELECT bases.id, bases.twitter_account from bases where twitter_account IN (#{account_list_st})", [])
    IO.inspect result[:rows]

    render conn, msg: "hogehoge" <> _params["accounts"]
  end

end
