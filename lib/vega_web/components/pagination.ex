defmodule VegaWeb.Components.Pagination do
  @moduledoc """
  node title
  """
  use Phoenix.Component
  alias VegaWeb.Router.Helpers, as: Routes

  def prev_page_button(%{has_prev: true, prev_page: _prev_page, user: _user} = assigns) do
    ~H"""
    <.link
      navigate={Routes.page_path(VegaWeb.Endpoint, :user_detail, @user.username, page: @prev_page)}
      class="inline-flex items-center px-4 py-2 border border-slate-300 shadow-sm text-sm font-medium rounded-md text-slate-700 bg-white hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
    >
      &larr; Previous
    </.link>
    """
  end

  def prev_page_button(%{has_prev: true, prev_page: _prev_page} = assigns) do
    ~H"""
    <.link
      navigate={Routes.page_path(VegaWeb.Endpoint, :index, page: @prev_page)}
      class="inline-flex items-center px-4 py-2 border border-slate-300 shadow-sm text-sm font-medium rounded-md text-slate-700 bg-white hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
    >
      &larr; Previous
    </.link>
    """
  end

  def prev_page_button(%{has_prev: false} = assigns) do
    ~H"""
    <span class="inline-flex items-center px-4 py-2 border border-slate-200 text-sm font-medium rounded-md text-slate-400 bg-slate-50 cursor-not-allowed">
      &larr; Previous
    </span>
    """
  end

  def next_page_button(%{has_next: true, next_page: _next_page, user: _user} = assigns) do
    ~H"""
    <.link
      navigate={Routes.page_path(VegaWeb.Endpoint, :user_detail, @user.username, page: @next_page)}
      class="inline-flex items-center px-4 py-2 border border-slate-300 shadow-sm text-sm font-medium rounded-md text-slate-700 bg-white hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
    >
      Next &rarr;
    </.link>
    """
  end

  def next_page_button(%{has_next: true, next_page: _next_page} = assigns) do
    ~H"""
    <.link
      navigate={Routes.page_path(VegaWeb.Endpoint, :index, page: @next_page)}
      class="inline-flex items-center px-4 py-2 border border-slate-300 shadow-sm text-sm font-medium rounded-md text-slate-700 bg-white hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
    >
      Next &rarr;
    </.link>
    """
  end

  def next_page_button(%{has_next: false} = assigns) do
    ~H"""
    <span class="inline-flex items-center px-4 py-2 border border-slate-200 text-sm font-medium rounded-md text-slate-400 bg-slate-50 cursor-not-allowed">
      Next &rarr;
    </span>
    """
  end

  def pagination(
        %{
          user: _user
        } = assigns
      ) do
    ~H"""
    <nav class="flex items-center justify-between">
      <div class="flex-1 flex justify-between sm:hidden">
        <.prev_page_button user={@user} prev_page={@prev_page} has_prev={@has_prev} />
        <.next_page_button user={@user} next_page={@next_page} has_next={@has_next} />
      </div>
      <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
        <div>
          <p class="text-sm text-slate-700">
            Page <span class="font-medium">{@page}</span>
          </p>
        </div>
        <div class="flex gap-2">
          <.prev_page_button user={@user} prev_page={@prev_page} has_prev={@has_prev} />
          <.next_page_button user={@user} next_page={@next_page} has_next={@has_next} />
        </div>
      </div>
    </nav>
    """
  end

  def pagination(assigns) do
    ~H"""
    <nav class="flex items-center justify-between">
      <div class="flex-1 flex justify-between sm:hidden">
        <.prev_page_button prev_page={@prev_page} has_prev={@has_prev} />
        <.next_page_button next_page={@next_page} has_next={@has_next} />
      </div>
      <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
        <div>
          <p class="text-sm text-slate-700">
            Page <span class="font-medium">{@page}</span>
          </p>
        </div>
        <div class="flex gap-2">
          <.prev_page_button prev_page={@prev_page} has_prev={@has_prev} />
          <.next_page_button next_page={@next_page} has_next={@has_next} />
        </div>
      </div>
    </nav>
    """
  end
end
