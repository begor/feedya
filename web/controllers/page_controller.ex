defmodule Feedya.PageController do
  use Feedya.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, [handler: Feedya.SessionController] when not action in [:index]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "profile.html", user: user)
  end
end
