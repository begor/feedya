defmodule Feedya.PageController do
  use Feedya.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
