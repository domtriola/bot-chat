defmodule Chat.ConvoTest do
  use Chat.ModelCase

  alias Chat.Convo

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Convo.changeset(%Convo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Convo.changeset(%Convo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
