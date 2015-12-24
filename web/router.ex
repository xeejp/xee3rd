defmodule Xee3rd.Router do
  use Xee3rd.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Xee3rd do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/experiment/:x_id", ExperimentController, :index
    get "/experiment/:x_id/host", ExperimentController, :host
  end

  # Other scopes may use custom stacks.
  # scope "/api", Xee3rd do
  #   pipe_through :api
  # end
end
