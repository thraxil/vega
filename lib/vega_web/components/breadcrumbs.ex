defmodule VegaWeb.Components.Breadcrumbs do
  @moduledoc """
  breadcrumbs components
  """
  use Phoenix.Component
  alias VegaWeb.Router.Helpers, as: Routes
  import Phoenix.HTML.{Link}

  def breadcrumbs(assigns) do
    ~H"""
    <div class="breadcrumbs">
    <ul>
    <%= render_slot(@inner_block) %>
    </ul>
    </div>
    """
  end
  
  def breadcrumb_root(assigns) do
    ~H"""
    <li>// <%= link("thraxil.org", to: Routes.page_path(VegaWeb.Endpoint, :index)) %></li>
    """
  end

  def breadcrumb_users(assigns) do
    ~H"""
    <.breadcrumb_root></.breadcrumb_root>
    <li><%= link("users", to: Routes.page_path(VegaWeb.Endpoint, :user_index)) %></li>
    """
  end

  def breadcrumb(%{user: user, type: type, year: year, month: month, day: day} = assigns) do
    ~H"""
    <.breadcrumb user={user} type={type} year={year} month={month}></.breadcrumb>
    <li><%= link(day, to: Routes.page_path(VegaWeb.Endpoint, :user_type_year_month_day_index, user.username, type <> "s", year, month, day)) %></li>
    """
  end

  def breadcrumb(%{user: user, type: type, year: year, month: month} = assigns) do
    ~H"""
    <.breadcrumb user={user} type={type} year={year}></.breadcrumb>
    <li><%= link(month, to: Routes.page_path(VegaWeb.Endpoint, :user_type_year_month_index, user.username, type <> "s", year, month)) %></li>
    """
  end

  def breadcrumb(%{user: user, type: type, year: year} = assigns) do
    ~H"""
    <.breadcrumb user={user} type={type}></.breadcrumb>
    <li><%= link(year, to: Routes.page_path(VegaWeb.Endpoint, :user_type_year_index, user.username, type <> "s", year)) %></li>
    """
  end

  def breadcrumb(%{user: user, type: type} = assigns) do
    ~H"""
    <.breadcrumb user={user}></.breadcrumb>
    <li><%= link(type <> "s", to: Routes.page_path(VegaWeb.Endpoint, :user_type_index, user.username, type <> "s")) %></li>
    """
  end

  def breadcrumb(%{user: user} = assigns) do
    ~H"""
    <.breadcrumb_users></.breadcrumb_users>
    <li><%= link(user.username, to: Routes.page_path(VegaWeb.Endpoint, :user_detail, user.username)) %></li>
    """
  end


end
