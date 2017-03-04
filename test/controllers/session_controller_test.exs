defmodule Feedya.SessionControllerTest do
  use Feedya.ConnCase

  alias Feedya.{User, Repo}

  @valid_login %{email: "john@doe.net", password: "qwerty123"}
  @invalid_login %{email: "john@doe.net", password: "qwerty124"}

  setup do
    changeset = User.changeset(%User{}, %{email: "john@doe.net",
                                          first_name: "John",
                                          password: "qwerty123",
                                          password_confirmation: "qwerty123"})
    Repo.insert(changeset)
    :ok
  end

  test "GET /login", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200)
  end

  test "valid POST /login", %{conn: conn} do
    conn = post conn, "/login", %{"user" => @valid_login}
    assert redirected_to(conn) =~ page_path(conn, :profile)
  end

  test "invalid POST /login", %{conn: conn} do
    conn = post conn, "/login", %{"user" => @invalid_login}
    assert redirected_to(conn) =~ session_path(conn, :login)
  end
end
