defmodule Chat.ConvoChannel do
  use Chat.Web, :channel

  alias Chat.Convo
  alias Chat.MessageView

  def join("convos:" <> convo_id, params, socket) do
    convo = Repo.get!(Convo, convo_id)
    messages = Repo.all(
      from msg in assoc(convo, :messages),
          order_by: [asc: msg.inserted_at],
          limit: 200,
          preload: [:user]
      )

    resp = %{messages: Phoenix.View.render_many(messages,
                                                MessageView,
                                                "message.json")}

    {:ok, resp, assign(socket, :convo_id, convo_id)}
  end

  def handle_in(event, params, socket) do

  end

  def handle_in("new_message", params, user, socket) do

  end

  defp broadcast_message(socket, message) do

  end

  defp message_bot(message, socket) do

  end
end
