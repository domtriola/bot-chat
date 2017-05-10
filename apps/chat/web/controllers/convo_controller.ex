defmodule Chat.ConvoController do
  use Chat.Web, :controller

  alias Chat.Convo

  plug :authenticate_user when action in [:show]

  def create(conn, %{"convo" => convo_params}) do
    changeset = Convo.changeset(%Convo{}, convo_params)

    case Repo.insert(changeset) do
      {:ok, _convo} ->
        conn
        |> put_flash(:info, "Convo created successfully.")
        |> redirect(to: convo_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    convo = Repo.get!(Convo, id)

    render(conn, "show.html", convo: convo)
  end

  def update(conn, %{"id" => id, "convo" => convo_params}) do
    convo = Repo.get!(Convo, id)
    changeset = Convo.changeset(convo, convo_params)

    case Repo.update(changeset) do
      {:ok, convo} ->
        conn
        |> put_flash(:info, "Convo updated successfully.")
        |> redirect(to: convo_path(conn, :show, convo))
      {:error, changeset} ->
        render(conn, "edit.html", convo: convo, changeset: changeset)
    end
  end
end
