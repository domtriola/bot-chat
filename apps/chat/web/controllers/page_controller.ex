defmodule Chat.PageController do
  use Chat.Web, :controller

  plug :authenticate_user when action in [:index]

  def index(conn, _params) do
    clever = Chat.Repo.get_by(Chat.Convo, title: "CleverBot")
    redirect conn, to: "/convos/#{clever.id}"
  end
end
