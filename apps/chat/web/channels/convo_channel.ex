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

    socket =
      socket
      |> assign(:cs, "")
      |> assign(:convo_id, convo_id)

    {:ok, resp, socket}
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
        socket = message_bot(msg, socket)
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
    convo = Repo.get(Convo, socket.assigns.convo_id)

    case convo.title do
      "CleverBot" ->
        message(message, socket)
      _else ->
        socket
    end
  end
  defp message(message, socket) do
    result = Bots.query_bot(message.body, socket.assigns.cs)
    attrs = %{body: result.text, cs: result.cs}

    changeset =
      Repo.get_by!(Chat.User, username: result.bot)
      |> build_assoc(:messages, convo_id: message.convo_id)
      |> Chat.Message.changeset(attrs)

    case Repo.insert(changeset) do
      {:ok, msg} -> broadcast_message(socket, msg)
      {:error, _changeset} -> :ignore
    end

    assign(socket, :cs, result.cs)
  end
end
