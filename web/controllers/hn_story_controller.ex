defmodule Feedya.HNStoryController do
  use Feedya.Web, :controller

  alias Feedya.{Repo, HNStory}

  plug Guardian.Plug.EnsureAuthenticated, [handler: Feedya.SessionController]

  def index(conn, _params) do
    render(conn, "index.html", stories: Repo.all(from h in HNStory,
                                                 order_by: [desc: h.hn_id]))
  end
end
