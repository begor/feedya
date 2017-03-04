defmodule Feedya.UserControllerTest do
  use Feedya.ConnCase

  alias Feedya.User

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "Introduce yourself"
  end

  test "creates when data is valid", %{conn: conn} do
    params = %{email: "example@test.com",
               first_name: "John",
               password: "qwerty123",
               password_confirmation: "qwerty123"}
    conn = post conn, user_path(conn, :create), user: params
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, params)
  end

  test "doesn't create when data is invalid", %{conn: conn} do
    params = %{email: "example@test.com",
               first_name: "John",
               password: "qwerty123",
               password_confirmation: "qwerty124"}
    conn = post conn, user_path(conn, :create), user: params
    assert html_response(conn, 200) =~ "Introduce yourself"
  end
end
