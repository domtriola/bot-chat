defmodule Chat.MessageView do
  use Chat.Web, :view

  def render("message.json", %{message: msg}) do
    %{
      id: msg.id,
      body: msg.body,
      user: msg.user.username,
      created_at: msg.inserted_at
    }
  end
end
