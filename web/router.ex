defmodule SanaServerPhoenix.Router do
  use SanaServerPhoenix.Web, :router

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

  scope "/", SanaServerPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", SanaServerPhoenix do
    pipe_through :api
    resources "/anime/v1/twitter/follower/status", TwitterFollowerStatusController, only: [:index]
    resources "/anime/v1/twitter/follower/history", TwitterFollowerHistoryController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SanaServerPhoenix do
  #   pipe_through :api
  # end
end
