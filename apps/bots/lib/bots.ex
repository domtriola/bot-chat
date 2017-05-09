defmodule Bots do
  @bots %{"CleverBot" => Bots.CleverBot}

  defmodule Result do
    defstruct text: nil, bot: nil, cs: nil
  end

  def query_bot(msg, cs, opts \\ []) do
    bot = opts[:bot] || @bots["CleverBot"]

    bot.query(msg, cs)
  end
end
