defmodule Chat.PageController do
  use Chat.Web, :controller

  plug :authenticate_user when action in [:index]

  def index(conn, _params) do
    general = Chat.Repo.get_by(Chat.Convo, title: "General")
    redirect conn, to: "/convos/#{general.id}"
  end
end
