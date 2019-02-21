defmodule SspExWeb.Router do
  use SspExWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SspExWeb do
    pipe_through :api

    post "/req", ApiController, :execute
  end
end
