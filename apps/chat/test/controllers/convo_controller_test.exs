defmodule Chat.ConvoControllerTest do
  use Chat.ConnCase

  alias Chat.Convo
  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, convo_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing convos"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, convo_path(conn, :new)
    assert html_response(conn, 200) =~ "New convo"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, convo_path(conn, :create), convo: @valid_attrs
    assert redirected_to(conn) == convo_path(conn, :index)
    assert Repo.get_by(Convo, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, convo_path(conn, :create), convo: @invalid_attrs
    assert html_response(conn, 200) =~ "New convo"
  end

  test "shows chosen resource", %{conn: conn} do
    convo = Repo.insert! %Convo{}
    conn = get conn, convo_path(conn, :show, convo)
    assert html_response(conn, 200) =~ "Show convo"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, convo_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    convo = Repo.insert! %Convo{}
    conn = get conn, convo_path(conn, :edit, convo)
    assert html_response(conn, 200) =~ "Edit convo"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    convo = Repo.insert! %Convo{}
    conn = put conn, convo_path(conn, :update, convo), convo: @valid_attrs
    assert redirected_to(conn) == convo_path(conn, :show, convo)
    assert Repo.get_by(Convo, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    convo = Repo.insert! %Convo{}
    conn = put conn, convo_path(conn, :update, convo), convo: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit convo"
  end

  test "deletes chosen resource", %{conn: conn} do
    convo = Repo.insert! %Convo{}
    conn = delete conn, convo_path(conn, :delete, convo)
    assert redirected_to(conn) == convo_path(conn, :index)
    refute Repo.get(Convo, convo.id)
  end
end
