defmodule Feedya.HN.StoryController do
  use Feedya.Web, :controller

  alias Feedya.{Repo, HN.Story}

  plug Guardian.Plug.EnsureAuthenticated, [handler: Feedya.SessionController]

  def index(conn, _params) do
    stories = Repo.all(from h in Story, order_by: [desc: h.score])
    render(conn, "index.html", stories: stories)
  end
end
