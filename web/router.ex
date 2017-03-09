defmodule Feedya.Router do
  use Feedya.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "/", Feedya do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    resources "/users", UserController
    resources "/hn/stories", HN.StoryController
    resources "/hn", HNSubscriptionController

    get "/", PageController, :index
    get "/my", PageController, :profile
    get "/login", SessionController, :login
    post "/login", SessionController, :login!
    get "/logout", SessionController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", Feedya do
  #   pipe_through :api
  # end
end
