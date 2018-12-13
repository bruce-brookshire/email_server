defmodule EmailServerWeb.Router do
  use EmailServerWeb, :router

  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", EmailServerWeb do
    pipe_through :api

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", EmailServerWeb do
  #   pipe_through :api
  # end
end
