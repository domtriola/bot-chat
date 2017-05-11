defmodule Identicon do
  alias Identicon.Image

  def process(text) do
    %Image{text: text}
    |> gen_hash()
    |> gen_color()
    |> gen_grid()
    |> gen_pix()
  end

  def write_image(text) do
    pix = Identicon.process(text)
    File.write("apps/chat/web/static/assets/images/avatars/#{text}.png", pix)
  end

  defp gen_hash(%Image{text: text} = image) do
    hash =
      :crypto.hash(:sha256, text)
      |> :binary.bin_to_list

    %Image{image | hash: hash}
  end

  defp gen_color(%Image{hash: [red, green, blue | _rest]} = image) do
    %Image{image | color: {red, green, blue}}
  end

  defp gen_grid(%Image{hash: hash} = image) do
    grid =
      hash
      |> gen_t_left()
      |> gen_t_right()
      |> gen_bottom()
      |> Enum.flat_map(&(coords(&1)))

    %Image{image | grid: grid}
  end

  defp gen_t_left(hash) do
    t_left =
      hash
      |> Enum.take(25)
      |> Enum.chunk(5)

    %{t_left: t_left}
  end

  defp gen_t_right(%{t_left: t_left} = grid) do
    t_right =
      t_left
      |> Enum.map(&(Enum.reverse/1))

    Map.put(grid, :t_right, t_right)
  end

  defp gen_bottom(%{t_left: t_left, t_right: t_right} = grid) do
    b_left =
      t_left
      |> Enum.reverse()

    b_right =
      t_right
      |> Enum.reverse()

    Map.put(grid, :b_left, b_left)
    |> Map.put(:b_right, b_right)
  end

  defp coords({quadrant, grid}) do
    offset =
      case quadrant do
        :t_left ->
          %{x: 0, y: 0}
        :t_right ->
          %{x: 200, y: 0}
        :b_left ->
          %{x: 0, y: 200}
        :b_right ->
          %{x: 200, y: 200}
      end

    Enum.flat_map Enum.with_index(grid), fn({row, row_i}) ->
      Enum.map Enum.with_index(row), fn({val, val_i}) ->
        sx = val_i * 40 + offset.x
        sy = row_i * 40 + offset.y
        ex = sx + 40
        ey = sy + 40

        {val, {sx, sy}, {ex, ey}}
      end
    end
  end

  defp gen_pix(%Image{grid: grid, color: color}) do
    pix = :egd.create(400, 400)
    fill_color = :egd.color(color)


    Enum.each grid, fn({val, start, stop}) ->
      if rem(val, 2) == 0 do
        :egd.filledRectangle(pix, start, stop, fill_color)
      end
    end

    :egd.render(pix)
  end
end
