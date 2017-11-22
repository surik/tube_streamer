defmodule TubeStreamerWeb.Router do
  use TubeStreamerWeb, :router

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

  pipeline :swagger_spec do
    plug :accepts, ["json", "html"]
  end

  scope "/", TubeStreamerWeb do
    pipe_through :browser # Use the default browser stack

    get "/",             PageController, :index
    get "/stream/:url",  PageController, :stream
  end

  scope "/api", TubeStreamerWeb.Api do
    scope "/v1", V1 do
      pipe_through :api

      get "/stream/:url",   StreamController, :index
      get "/info/:url",     StreamController, :info
    end
  end

  scope "/api" do
    pipe_through :swagger_spec
    scope "/v1" do
      forward "/", TubeStreamerWeb.ApiSwaggerUi.Controller
    end
  end
end