defmodule VegaWeb.Components.Breadcrumbs do
  @moduledoc """
  breadcrumbs components
  """
  use Phoenix.Component
  alias VegaWeb.Router.Helpers, as: Routes

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
    <li>// <.link navigate={Routes.page_path(VegaWeb.Endpoint, :index)}>thraxil.org</.link></li>
    """
  end

  def breadcrumb_users(assigns) do
    ~H"""
    <.breadcrumb_root></.breadcrumb_root>
    <li><.link navigate={Routes.page_path(VegaWeb.Endpoint, :user_index)}>users</.link></li>
    """
  end

  def breadcrumb(%{user: _user, type: _type, year: _year, month: _month, day: _day} = assigns) do
    ~H"""
    <.breadcrumb user={@user} type={@type} year={@year} month={@month}></.breadcrumb>
    <li>
      <.link navigate={
        Routes.page_path(
          VegaWeb.Endpoint,
          :user_type_year_month_day_index,
          @user.username,
          @type <> "s",
          @year,
          @month,
          @day
        )
      }>
        <%= @day %>
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user, type: _type, year: _year, month: _month} = assigns) do
    ~H"""
    <.breadcrumb user={@user} type={@type} year={@year}></.breadcrumb>
    <li>
      <.link navigate={
        Routes.page_path(
          VegaWeb.Endpoint,
          :user_type_year_month_index,
          @user.username,
          @type <> "s",
          @year,
          @month
        )
      }>
        <%= @month %>
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user, type: _type, year: _year} = assigns) do
    ~H"""
    <.breadcrumb user={@user} type={@type}></.breadcrumb>
    <li>
      <.link navigate={
        Routes.page_path(VegaWeb.Endpoint, :user_type_year_index, @user.username, @type <> "s", @year)
      }>
        <%= @year %>
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user, type: _type} = assigns) do
    ~H"""
    <.breadcrumb user={@user}></.breadcrumb>
    <li>
      <.link navigate={
        Routes.page_path(VegaWeb.Endpoint, :user_type_index, @user.username, @type <> "s")
      }>
        <%= @type <> "s" %>
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user} = assigns) do
    ~H"""
    <.breadcrumb_users></.breadcrumb_users>
    <li>
      <.link navigate={Routes.page_path(VegaWeb.Endpoint, :user_detail, @user.username)}>
        <%= @user.username %>
      </.link>
    </li>
    """
  end
end
