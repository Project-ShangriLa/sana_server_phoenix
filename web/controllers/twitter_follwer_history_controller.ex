defmodule SanaServerPhoenix.TwitterFollwerHistoryController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do
    account = "'" <> _params["account"] <> "'"

    #SELECT h.follower, h.updated_at
    #      from twitter_status_histories as h,
    #       (SELECT id FROM bases WHERE twitter_account = 'usagi_anime' order by id desc limit 1) b
    #      where h.bases_id = b.id AND h.updated_at < '2014-08-09 14:35:41' order by h.updated_at desc limit 100

    {:ok, twitter_status } = Ecto.Adapters.SQL.query(Repo,
      "SELECT follower, updated_at
      from twitter_statuses (
       SELECT id FROM bases WHERE twitter_account = #{account} order by id desc limit 1)
      ) b
      where twitter_status_histories.bases_id = b.id order by updated_at asc limit 100", [])

    dict = HashDict.new
    dict = List.foldr(twitter_status[:rows], dict,
    fn (x, acc) ->
      [twitter_account, follower, updated_at] = x
      check = HashDict.put(acc, twitter_account, %{:follower => follower, :updated_at => UnixTime.convert_date_to_unixtime(updated_at)})
    end)

    render conn, msg: dict
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
