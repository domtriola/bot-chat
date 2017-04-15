defmodule Chat.ConvoPlug do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    convos = repo.all(Chat.Convo)
    conn
    |> assign(:convos, convos)
  end
end
