defmodule DepartureBoardUi.Router do
  use DepartureBoardUi.Web, :router

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

  scope "/", DepartureBoardUi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end

  scope "/slack", DepartureBoardUi do
    pipe_through :api

    post "/board", SlackController, :fetch
  end

  # Other scopes may use custom stacks.
  scope "/api", DepartureBoardUi do
    pipe_through :api

    resources "/stations", StationController, except: [:new, :edit ] #, :delete, :create]
    get "/departureboard/:token", DepartureBoardController, :fetch
    get "/departureboard/:station_name/:departure_date/:departure_time", DepartureBoardController, :show
  end
end
