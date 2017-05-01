defmodule Bots do
  @bots %{"CleverBot" => Bots.CleverBot}

  defmodule Result do
    defstruct text: nil, bot: nil
  end

  def query_bot(msg, opts \\ []) do
    bot = opts[:bot] || @bots["CleverBot"]

    bot.query(msg)
  end
end
