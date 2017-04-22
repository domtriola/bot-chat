defmodule Chat.ConvoChannel do
  use Chat.Web, :channel

  alias Chat.Convo
  alias Chat.Message
  alias Chat.MessageView

  def join("convos:" <> convo_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    convo_id = String.to_integer(convo_id)

    convo = Repo.get!(Convo, convo_id)
    messages = Repo.all(
      from msg in assoc(convo, :messages),
          where: msg.id > ^last_seen_id,
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
    user = Repo.get!(Chat.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_message", params, user, socket) do
    changeset =
      user
      |> build_assoc(:messages, convo_id: socket.assigns.convo_id)
      |> Message.changeset(params)

    case Repo.insert(changeset) do
      {:ok, msg} ->
        broadcast_message(socket, msg)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  defp broadcast_message(socket, message) do
    msg = Repo.preload(message, :user)
    rendered_msg = Phoenix.View.render(MessageView,
                                       "message.json",
                                       %{message: msg})

    broadcast! socket, "new_message", rendered_msg
  end

  defp message_bot(message, socket) do

  end
end
