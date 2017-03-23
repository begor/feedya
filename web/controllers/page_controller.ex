defmodule Feedya.PageController do
  use Feedya.Web, :controller

  alias Feedya.HN.Subscription

  plug Guardian.Plug.EnsureAuthenticated, [handler: Feedya.SessionController] when not action in [:index]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    subs = Subscription.by_user(user)
    render(conn, "profile.html", user: user, hn_subscriptions: subs)
  end
end
