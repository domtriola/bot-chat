defmodule Chat.ConvoController do
  use Chat.Web, :controller

  alias Chat.Convo

  def index(conn, _params) do
    convos = Repo.all(Convo)
    render(conn, "index.html", convos: convos)
  end

  def new(conn, _params) do
    changeset = Convo.changeset(%Convo{})
    render(conn, "new.html", changeset: changeset)
  end

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

  def edit(conn, %{"id" => id}) do
    convo = Repo.get!(Convo, id)
    changeset = Convo.changeset(convo)
    render(conn, "edit.html", convo: convo, changeset: changeset)
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

  def delete(conn, %{"id" => id}) do
    convo = Repo.get!(Convo, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(convo)

    conn
    |> put_flash(:info, "Convo deleted successfully.")
    |> redirect(to: convo_path(conn, :index))
  end
end
