defmodule Chat.SessionController do
  use Chat.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username,
                                    "password" => password}}) do
    case Chat.Auth.login_by_username_and_password(
          conn, username, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back #{username}!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Chat.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
