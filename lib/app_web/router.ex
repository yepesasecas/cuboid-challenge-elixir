defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppWeb do
    pipe_through :api
    resources "/cuboids", CuboidController
    resources "/bags", BagController
  end
end
