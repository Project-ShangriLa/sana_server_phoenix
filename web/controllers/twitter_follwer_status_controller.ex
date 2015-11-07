defmodule SanaServerPhoenix.TwitterFollwerStatusController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do

    # http://hexdocs.pm/ecto/Ecto.Adapters.SQL.html#query/4
    account_list = Enum.join(String.split(_params["accounts"],","), "\",\"")

    # <> で文字列連結
    account_list_st = "\"" <> account_list <> "\""

    {:ok, twitter_status } = Ecto.Adapters.SQL.query(Repo,
      "SELECT b.twitter_account, follower, updated_at
      from twitter_statuses, (
       SELECT id, twitter_account FROM bases where twitter_account IN (#{account_list_st})
      ) b
      where twitter_statuses.bases_id = b.id order by updated_at desc", [])

    check = {:xx}
    response_data = Enum.map twitter_status[:rows], fn(x) ->
      [twitter_account, follower, updated_at] = x
      check = Tuple.append(check, twitter_account)
      #  IO.inspect check
      #%{:twitter_account => twitter_account, :follower => follower, :updated_at => UnixTime.convert_date_to_unixtime(updated_at)}
    end

    #Recursion.exe(twitter_status[:rows], length(twitter_status[:rows]) - 1)

    # List.foldr(twitter_status[:rows], check, fn (x, acc) -> check = Tuple.append(acc, x) end)
    dict = HashDict.new
    dict = List.foldr(twitter_status[:rows], dict,
    fn (x, acc) ->
      [twitter_account, follower, updated_at] = x
      check = HashDict.put(acc, twitter_account, %{:follower => follower, :updated_at => UnixTime.convert_date_to_unixtime(updated_at)})
    end)
    #IO.inspect length(twitter_status[:rows])
    #変数dump
    IO.inspect dict
    IO.inspect check
    IO.inspect response_data

    render conn, msg: dict
  end

end

defmodule Recursion do
  def exe(msg, n) when n <= 0 do
    IO.inspect n
    IO.inspect is_list(msg)
  end

  def exe(msg, n) do
    IO.inspect n
    IO.inspect List.last(msg)
    exe(msg, n - 1)
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
