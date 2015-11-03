defmodule SanaServerPhoenix.StatusController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do
    #パラメーターを受け取る _params["accounts"]
    #アカウントリストを分解
    #MySQLからデータを取得
    #Baseテーブルを検索しIDを取得
    #IDからTwitterのステートを取得

  #  {:ok, result} = Mariaex.Connection.query(p, "SELECT * FROM bases where twitter_account IN '#{_params["accounts"]}'")
  #  IO.inspect result
    {:ok, result } = Ecto.Adapters.SQL.query(Repo, "SELECT * from bases", [])
    IO.inspect result

    render conn, msg: "hogehoge" <> _params["accounts"]
  end

end
