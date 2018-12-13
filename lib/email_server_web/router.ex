defmodule EmailServerWeb.Router do
  use EmailServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", EmailServerWeb do
    pipe_through :api

    post "/mailer", Mailer, :send_mail
  end

end
