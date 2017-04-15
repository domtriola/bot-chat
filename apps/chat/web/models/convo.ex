defmodule Chat.Convo do
  use Chat.Web, :model

  schema "convos" do
    field :title, :string
    has_many :messages, Chat.Message

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
