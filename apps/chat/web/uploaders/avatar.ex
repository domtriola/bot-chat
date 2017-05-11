defmodule Chat.Avatar do
  use Arc.Definition

  @versions [:original]

  # Override the storage directory:
  def storage_dir(_version, {file, scope}) do
    "web/static/assets/images/avatars"
  end
end
