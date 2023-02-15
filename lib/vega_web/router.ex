defmodule VegaWeb.Router do
  use VegaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {VegaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VegaWeb do
    get "/feeds/main/", RssController, :index
    get "/users/:username/feeds/main/", RssController, :user_index
  end

  scope "/", VegaWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/search", PageController, :search_results

    get "/tags/", PageController, :tag_index
    get "/tags/:slug", PageController, :tag_detail

    get "/users/", PageController, :user_index
    get "/users/:username", PageController, :user_detail
    get "/users/:username/:type", PageController, :user_type_index
    get "/users/:username/:type/:year", PageController, :user_type_year_index
    get "/users/:username/:type/:year/:month", PageController, :user_type_year_month_index

    get "/users/:username/:type/:year/:month/:day",
        PageController,
        :user_type_year_month_day_index

    get "/users/:username/:type/:year/:month/:day/:slug", PageController, :node_detail
  end

  # Other scopes may use custom stacks.
  # scope "/api", VegaWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VegaWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
