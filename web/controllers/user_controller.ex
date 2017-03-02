defmodule Feedya.UserController do
  use Feedya.Web, :controller

  alias Feedya.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> redirect(to: page_path(conn, :profile))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
