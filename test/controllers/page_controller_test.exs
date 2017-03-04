defmodule Feedya.PageControllerTest do
  use Feedya.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "unauthenticated GET /my", %{conn: conn} do
    conn = get conn, "/my"
    assert redirected_to(conn) =~ session_path(conn, :login)
  end
end
