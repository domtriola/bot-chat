defmodule Chat.ConvoChannel do
  use Chat.Web, :channel

  def join("convos:" <> convo_id, params, socket) do
    resp = "testing"

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
