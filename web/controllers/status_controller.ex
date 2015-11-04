defmodule SanaServerPhoenix.StatusController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do

    # http://hexdocs.pm/ecto/Ecto.Adapters.SQL.html#query/4
    account_list = Enum.join(String.split(_params["accounts"],","), "\",\"")
    account_list_st = "\"" <> account_list <> "\""

    {:ok, twitter_status } = Ecto.Adapters.SQL.query(Repo,
      "SELECT bases_id, b.twitter_account , follower, updated_at
      from twitter_statuses, (
       SELECT id, twitter_account FROM bases where twitter_account IN (#{account_list_st})
      ) b
      where twitter_statuses.bases_id = b.id", [])

    response_data = Enum.map twitter_status[:rows], fn(x) ->
      [bases_id, twitter_account, follower, updated_at] = x
      rows = %{:twitter_account => twitter_account, :follower => follower, :updated_at => UnixTime.convert_date_to_unixtime(updated_at)}
    end

    #SQLのrow配列をハッシュに変換する
    response_map = %{
      :kinmosa_anime => %{:follower => 42000, :updated_at => 1411466007},
      :gochiusa_anime => %{:follower => 51345, :updated_at => 1411466008}
    }
    IO.inspect response_map

    render conn, msg: response_map
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
