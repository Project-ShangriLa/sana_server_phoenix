defmodule SanaServerPhoenix.StatusController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do

    # http://hexdocs.pm/ecto/Ecto.Adapters.SQL.html#query/4
    #パラメーターを受け取る _params["accounts"]
    account_list = Enum.join(String.split(_params["accounts"],","), "\",\"")
    account_list_st = "\"" <> account_list <> "\""

    accounts_map = %{}
    #Baseテーブルを検索しIDを取得
    {:ok, result } = Ecto.Adapters.SQL.query(Repo, "SELECT bases.id, bases.twitter_account from bases where twitter_account IN (#{account_list_st})", [])
    IO.inspect result[:rows]

    Enum.each result[:rows], fn(x) ->
      [bases_id, twitter_account] = x
      #accounts_map[bases_id] = twitter_account
    end

    ids = '"27","166"'

    {:ok, twitter_status } = Ecto.Adapters.SQL.query(Repo, "SELECT bases_id, follower, updated_at from twitter_statuses where bases_id IN (#{ids})", [])

    response_data = Enum.map twitter_status[:rows], fn(x) ->
      [bases_id, follower, updated_at] = x
      rows = %{:bases_id => bases_id, :follower => follower, :updated_at => UnixTime.convert_date_to_unixtime(updated_at)}
    end

    render conn, msg: response_data
  end

end

defmodule UnixTime do

  def convert_date_to_unixtime(created_at) do
    #JSTなので9Hにしておく
    epoch = {{1970, 1, 1}, {9, 0, 0}}
    epoch_gs = :calendar.datetime_to_gregorian_seconds(epoch)

    {{year, month, day}, {hour, minute, second, msec}} = created_at
    gs = :calendar.datetime_to_gregorian_seconds({{year, month, day}, {hour, minute, second}})
    gs - epoch_gs
  end

end
