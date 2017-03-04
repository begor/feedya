defmodule Feedya.SessionController do
  use Feedya.Web, :controller

  alias Feedya.User

  def login(conn, _) do
    render(conn, "login.html", changeset: User.changeset(%User{}))
  end

  def login!(conn, %{"user" => user_params}) do
    case User.find_and_confirm_password(user_params) do
      {:ok, user} ->
         conn
         |> Guardian.Plug.sign_in(user)
         |> put_flash(:info, "Welcome back")
         |> redirect(to: "/my")
      {:error, _} ->
        conn
        |> put_flash(:error, "Check your password and email")
        |> redirect(to: "/login")
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end

  # handle the case where no authenticated user
  # was found
  def unauthenticated(conn, _) do
    conn
    |> put_status(302)
    |> put_flash(:error, "You aren't allowed to do this")
    |> redirect(to: "/login")
  end
end
