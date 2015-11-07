defmodule SanaServerPhoenix.TwitterFollwerHistoryController do
  use SanaServerPhoenix.Web, :controller
  def index(conn, _params) do
    response = []

    account = "'" <> _params["account"] <> "'"
    param_end_date = _params["end_date"]

    #ElixirではIF判定はパターンマッチで行う
    end_date = case param_end_date do
      nil -> "now()"
      num -> "'" <> UnixTime.convert_unixtime_to_date(String.to_integer(param_end_date)) <> "'"
      _ -> render conn, msg: response
    end

    {:ok, twitter_status } = Ecto.Adapters.SQL.query(Repo,
      "SELECT h.follower, h.updated_at
      from twitter_status_histories as h,
      (SELECT id FROM bases WHERE twitter_account = #{account} order by id desc limit 1) b
       where h.bases_id = b.id AND h.updated_at < #{end_date} order by h.updated_at desc limit 100",
       [])

    response = List.foldr(twitter_status[:rows], response,
    fn (x, acc) ->
      [follower, updated_at] = x
      response = [%{:follower => follower, :updated_at => UnixTime.convert_date_to_unixtime(updated_at)}] ++ acc
    end)

    render conn, msg: response
  end

end

#http://michal.muskala.eu/2015/07/30/unix-timestamps-in-elixir.html
defmodule UnixTime do
  #JSTなので9Hにしておく
  epoch = {{1970, 1, 1}, {9, 0, 0}}
  @epoch :calendar.datetime_to_gregorian_seconds(epoch)

  def convert_date_to_unixtime(created_at) do
    {{year, month, day}, {hour, minute, second, msec}} = created_at
    gs = :calendar.datetime_to_gregorian_seconds({{year, month, day}, {hour, minute, second}})
    gs - @epoch
  end

  def convert_unixtime_to_date(timestamp) do
    {:ok, date_string} =
    timestamp
      |> +(@epoch)
      |> :calendar.gregorian_seconds_to_datetime
      |> Timex.Date.from
      |> Timex.DateFormat.format("%Y-%m-%d %H:%M:%S", :strftime)
    date_string
  end

end
