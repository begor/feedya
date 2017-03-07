defmodule Feedya.HNStoryController do
  use Feedya.Web, :controller

  alias Feedya.{Repo, HNStory}

  plug Guardian.Plug.EnsureAuthenticated, [handler: Feedya.SessionController]

  def index(conn, _params) do
    stories = Repo.all(from h in HNStory, order_by: [desc: h.score])
    render(conn, "index.html", stories: stories)
  end
end
