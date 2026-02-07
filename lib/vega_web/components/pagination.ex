defmodule VegaWeb.Components.Pagination do
  @moduledoc """
  node title
  """
  use Phoenix.Component
  alias VegaWeb.Router.Helpers, as: Routes

  def prev_page_button(%{has_prev: true, prev_page: _prev_page, user: _user} = assigns) do
    ~H"""
    <button class="btn">
      <.link navigate={
        Routes.page_path(VegaWeb.Endpoint, :user_detail, @user.username, page: @prev_page)
      }>
        &lt;&lt; prev
      </.link>
    </button>
    """
  end

  def prev_page_button(%{has_prev: true, prev_page: _prev_page} = assigns) do
    ~H"""
    <button class="btn">
      <.link navigate={Routes.page_path(VegaWeb.Endpoint, :index, page: @prev_page)}>
        &lt;&lt; prev
      </.link>
    </button>
    """
  end

  def prev_page_button(%{has_prev: false} = assigns) do
    ~H"""
    <button class="btn btn-disabled">&lt;&lt; prev</button>
    """
  end

  def next_page_button(%{has_next: true, next_page: _next_page, user: _user} = assigns) do
    ~H"""
    <button class="btn">
      <.link navigate={
        Routes.page_path(VegaWeb.Endpoint, :user_detail, @user.username, page: @next_page)
      }>
        next &gt;&gt;
      </.link>
    </button>
    """
  end

  def next_page_button(%{has_next: true, next_page: _next_page} = assigns) do
    ~H"""
    <button class="btn">
      <.link navigate={Routes.page_path(VegaWeb.Endpoint, :index, page: @next_page)}>
        next &gt;&gt;
      </.link>
    </button>
    """
  end

  def next_page_button(%{has_next: false} = assigns) do
    ~H"""
    <button class="btn btn-disabled">next &gt;&gt;</button>
    """
  end

  def pagination(
        %{
          user: _user
        } = assigns
      ) do
    ~H"""
    <div class="btn-group flex justify-center">
      <.prev_page_button user={@user} prev_page={@prev_page} has_prev={@has_prev} />
      <button class="btn btn-disabled">page {@page}</button>
      <.next_page_button user={@user} next_page={@next_page} has_next={@has_next} />
    </div>
    """
  end

  def pagination(assigns) do
    ~H"""
    <div class="btn-group flex justify-center">
      <.prev_page_button prev_page={@prev_page} has_prev={@has_prev} />
      <button class="btn btn-disabled">page {@page}</button>
      <.next_page_button next_page={@next_page} has_next={@has_next} />
    </div>
    """
  end
end
