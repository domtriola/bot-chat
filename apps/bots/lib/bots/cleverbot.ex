defmodule Bots.CleverBot do
  alias Bots.Result

  def query(msg) do
    {:ok, {_status, _headers, body}} =
      :httpc.request(
        String.to_char_list(
          "http://www.cleverbot.com/getreply" <>
          "?key=#{api_key()}" <>
          "&input=#{msg}")
      )

    body
    |> process_reply()
    |> format_result()
  end

  defp process_reply(body) do
    {:ok, reply} = Poison.decode(body)

    %{"output" => output,
      "cs" => cs,
      "conversation_id" => conversation_id
    } = reply

    {output, cs, conversation_id}
  end

  defp format_result({output, _cs, _conversation_id}) do
    %Result{text: output, bot: "CleverBot"}
  end

  defp api_key, do: Application.get_env(:bots, :cleverbot)[:api_key]
end
