defmodule Identicon.Avatar do
  use Arc.Definition

  @versions [:original]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, _scope}) do
    "avatars/"
  end
end
