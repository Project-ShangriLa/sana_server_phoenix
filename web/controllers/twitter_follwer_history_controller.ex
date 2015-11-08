defmodule SanaServerPhoenix.TwitterFollwerHistoryController do
  use SanaServerPhoenix.Web, :controller
  require Logger

  def index(conn, _params) do
    response = []

    #IO.inspect Logger.metadata()

    account = _params["account"]
    param_end_date = _params["end_date"]

    #ElixirではIFをパターンマッチで行う
    end_date = try do
      case param_end_date do
        nil -> DateUtil.now_format
        _ -> UnixTime.convert_unixtime_to_date(String.to_integer(param_end_date))
      end
    rescue
      e in ArgumentError -> e
      #Exception.messageで例外メッセージを取得
      Logger.warn "error param end_date. " <> Exception.message(e)
      DateUtil.now_format
    end

    #http://localhost:4000/anime/v1/twitter/follwer/history?account='t'%20OR%20't'%20=%20't'
    {:ok, twitter_status } = Ecto.Adapters.SQL.query(Repo,
      "SELECT h.follower, h.updated_at
      from twitter_status_histories as h,
      (SELECT id FROM bases WHERE twitter_account = ? order by id desc limit 1) b
       where h.bases_id = b.id AND h.updated_at < ? order by h.updated_at desc limit ?",
       [account, end_date, 100])

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

defmodule DateUtil do
  def now_format() do
    {:ok, date_string} =
      :erlang.localtime
      |> Timex.Date.from
      |> Timex.DateFormat.format("%Y-%m-%d %H:%M:%S", :strftime)
    date_string
  end
end
