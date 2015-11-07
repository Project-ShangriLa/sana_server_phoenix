defmodule SanaServerPhoenix.TwitterFollwerStatusController do
  use SanaServerPhoenix.Web, :controller

  def index(conn, _params) do

    # http://hexdocs.pm/ecto/Ecto.Adapters.SQL.html#query/4
    # IN句のプリペアードステートメント
    # http://rikutoto.blogspot.jp/2013/08/preparedstatementin.html
    # http://localhost:4000/anime/v1/twitter/follwer/status?accounts=')%20OR%201=1%20OR%20twitter_account%20IN%20('
    # SELECT id, twitter_account FROM bases where twitter_account IN ('\') OR 1=1 OR twitter_account IN (\'')
    account_list = String.split(_params["accounts"],",")

    prepared_statement_list = []
    prepared_statement_list = Enum.map(account_list, fn(x) ->
      prepared_statement_list = prepared_statement_list ++ ["?"]
    end)

    prepared_statement_in =  Enum.join(prepared_statement_list, ",")

    {:ok, twitter_status } = Ecto.Adapters.SQL.query(Repo,
      "SELECT b.twitter_account, follower, updated_at
      from twitter_statuses, (
       SELECT id, twitter_account FROM bases where twitter_account IN (#{prepared_statement_in})
      ) b
      where twitter_statuses.bases_id = b.id order by updated_at desc", account_list)

    dict = HashDict.new
    dict = List.foldr(twitter_status[:rows], dict,
    fn (x, acc) ->
      [twitter_account, follower, updated_at] = x
      check = HashDict.put(acc, twitter_account, %{:follower => follower, :updated_at => UnixTime.convert_date_to_unixtime(updated_at)})
    end)

    #変数dump
    #IO.inspect dict
    #IO.inspect check
    #IO.inspect response_data

    render conn, msg: dict
  end

end
