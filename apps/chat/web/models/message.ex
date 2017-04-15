defmodule Chat.Message do
  use Chat.Web, :model

  schema "messages" do
    field :body, :string
    belongs_to :user, Chat.User
    belongs_to :convo, Chat.Convo

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body])
  end
end
