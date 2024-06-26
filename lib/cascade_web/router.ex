defmodule CascadeWeb.Router do
  use CascadeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CascadeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CascadeWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/documents", DocumentLive.Index, :index
    live "/documents/new", DocumentLive.Index, :new
    live "/documents/:id/edit", DocumentLive.Index, :edit
    live "/documents/:id", DocumentLive.Show, :show
    live "/documents/:id/show/edit", DocumentLive.Show, :edit

    live "/authors", AuthorLive.Index, :index
    live "/authors/new", AuthorLive.Index, :new
    live "/authors/:id/edit", AuthorLive.Index, :edit
    live "/authors/:id", AuthorLive.Show, :show
    live "/authors/:id/show/edit", AuthorLive.Show, :edit

    live "/tags", TagLive.Index, :index
    live "/tags/new", TagLive.Index, :new
    live "/tags/:id/edit", TagLive.Index, :edit
    live "/tags/:id", TagLive.Show, :show
    live "/tags/:id/show/edit", TagLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", CascadeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cascade, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CascadeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
