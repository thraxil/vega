defmodule VegaWeb.Components.Breadcrumbs do
  @moduledoc """
  breadcrumbs components
  """
  use Phoenix.Component
  alias VegaWeb.Router.Helpers, as: Routes

  def breadcrumbs(assigns) do
    ~H"""
    <nav aria-label="Breadcrumb" class="mb-8">
      <ol role="list" class="flex items-center space-x-2 text-sm text-slate-500">
        {render_slot(@inner_block)}
      </ol>
    </nav>
    """
  end

  def breadcrumb_root(assigns) do
    ~H"""
    <li>
      <.link
        navigate={Routes.page_path(VegaWeb.Endpoint, :index)}
        class="hover:text-slate-900 transition-colors"
      >
        thraxil.org
      </.link>
    </li>
    """
  end

  def breadcrumb_users(assigns) do
    ~H"""
    <.breadcrumb_root></.breadcrumb_root>
    <li class="flex items-center">
      <svg
        class="h-4 w-4 text-slate-300 mx-1 flex-shrink-0"
        fill="currentColor"
        viewBox="0 0 20 20"
        aria-hidden="true"
      >
        <path d="M5.555 17.776l8-16 .894.448-8 16-.894-.448z" />
      </svg>
      <.link
        navigate={Routes.page_path(VegaWeb.Endpoint, :user_index)}
        class="hover:text-slate-900 transition-colors"
      >
        users
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user, type: _type, year: _year, month: _month, day: _day} = assigns) do
    ~H"""
    <.breadcrumb user={@user} type={@type} year={@year} month={@month}></.breadcrumb>
    <li class="flex items-center">
      <svg
        class="h-4 w-4 text-slate-300 mx-1 flex-shrink-0"
        fill="currentColor"
        viewBox="0 0 20 20"
        aria-hidden="true"
      >
        <path d="M5.555 17.776l8-16 .894.448-8 16-.894-.448z" />
      </svg>
      <.link
        navigate={
          Routes.page_path(
            VegaWeb.Endpoint,
            :user_type_year_month_day_index,
            @user.username,
            @type <> "s",
            @year,
            @month,
            @day
          )
        }
        class="hover:text-slate-900 transition-colors"
      >
        {String.pad_leading(to_string(@day), 2, "0")}
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user, type: _type, year: _year, month: _month} = assigns) do
    ~H"""
    <.breadcrumb user={@user} type={@type} year={@year}></.breadcrumb>
    <li class="flex items-center">
      <svg
        class="h-4 w-4 text-slate-300 mx-1 flex-shrink-0"
        fill="currentColor"
        viewBox="0 0 20 20"
        aria-hidden="true"
      >
        <path d="M5.555 17.776l8-16 .894.448-8 16-.894-.448z" />
      </svg>
      <.link
        navigate={
          Routes.page_path(
            VegaWeb.Endpoint,
            :user_type_year_month_index,
            @user.username,
            @type <> "s",
            @year,
            @month
          )
        }
        class="hover:text-slate-900 transition-colors"
      >
        {String.pad_leading(to_string(@month), 2, "0")}
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user, type: _type, year: _year} = assigns) do
    ~H"""
    <.breadcrumb user={@user} type={@type}></.breadcrumb>
    <li class="flex items-center">
      <svg
        class="h-4 w-4 text-slate-300 mx-1 flex-shrink-0"
        fill="currentColor"
        viewBox="0 0 20 20"
        aria-hidden="true"
      >
        <path d="M5.555 17.776l8-16 .894.448-8 16-.894-.448z" />
      </svg>
      <.link
        navigate={
          Routes.page_path(
            VegaWeb.Endpoint,
            :user_type_year_index,
            @user.username,
            @type <> "s",
            @year
          )
        }
        class="hover:text-slate-900 transition-colors"
      >
        {@year}
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user, type: _type} = assigns) do
    ~H"""
    <.breadcrumb user={@user}></.breadcrumb>
    <li class="flex items-center">
      <svg
        class="h-4 w-4 text-slate-300 mx-1 flex-shrink-0"
        fill="currentColor"
        viewBox="0 0 20 20"
        aria-hidden="true"
      >
        <path d="M5.555 17.776l8-16 .894.448-8 16-.894-.448z" />
      </svg>
      <.link
        navigate={Routes.page_path(VegaWeb.Endpoint, :user_type_index, @user.username, @type <> "s")}
        class="hover:text-slate-900 transition-colors"
      >
        {@type <> "s"}
      </.link>
    </li>
    """
  end

  def breadcrumb(%{user: _user} = assigns) do
    ~H"""
    <.breadcrumb_users></.breadcrumb_users>
    <li class="flex items-center">
      <svg
        class="h-4 w-4 text-slate-300 mx-1 flex-shrink-0"
        fill="currentColor"
        viewBox="0 0 20 20"
        aria-hidden="true"
      >
        <path d="M5.555 17.776l8-16 .894.448-8 16-.894-.448z" />
      </svg>
      <.link
        navigate={Routes.page_path(VegaWeb.Endpoint, :user_detail, @user.username)}
        class="hover:text-slate-900 transition-colors"
      >
        {@user.username}
      </.link>
    </li>
    """
  end
end
