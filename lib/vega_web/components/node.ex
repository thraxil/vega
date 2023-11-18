defmodule VegaWeb.Components.Node do
  @moduledoc """
  node title
  """
  use Phoenix.Component
  alias VegaWeb.Router.Helpers, as: Routes
  import Phoenix.HTML.{Tag}
  import Phoenix.HTML

  def node_link(assigns) do
    ~H"""
    <.link navigate={VegaWeb.PageView.node_path(@node)} class="text-slate-900">
      <%= @node.title %>
    </.link>
    """
  end

  def node_title(assigns) do
    ~H"""
    <h2 class="bg-slate-300 my-0 ">
      <.link navigate={VegaWeb.PageView.node_path(@node)} class="no-underline text-slate-900">
        <%= @node.title %>
      </.link>
    </h2>
    """
  end

  def article(assigns) do
    ~H"""
    <article class="prose my-10 shadow-md prose-lg text-slate-900 ">
      <%= render_slot(@inner_block) %>
    </article>
    """
  end

  @months %{
    1 => "Jan",
    2 => "Feb",
    3 => "Mar",
    4 => "Apr",
    5 => "May",
    6 => "Jun",
    7 => "Jul",
    8 => "Aug",
    9 => "Sep",
    10 => "Oct",
    11 => "Nov",
    12 => "Dec"
  }

  defp dformat_node(timestamp) do
    '~2..0B ~ts ~4..0B'
    |> :io_lib.format([timestamp.day, @months[timestamp.month], timestamp.year])
    |> List.to_string()
  end

  def byline(assigns) do
    ~H"""
    <p class="bg-slate-100 my-0">
      By
      <.link
        navigate={Routes.page_path(VegaWeb.Endpoint, :user_detail, @node.user.username)}
        class="text-slate-900"
      >
        <%= @node.user.fullname %>
      </.link>
       <%= dformat_node(@node.created) %>
    </p>
    """
  end

  def inline_byline(assigns) do
    ~H"""
    By
    <.link
      navigate={Routes.page_path(VegaWeb.Endpoint, :user_detail, @node.user.username)}
      class="text-slate-900"
    >
      <%= @node.user.fullname %>
    </.link> <%= dformat_node(@node.created) %>
    """
  end

  def node_tags(assigns) do
    ~H"""
    <%= if length(@node.tags) > 0 do %>
      <p>
        Tags:
        <%= for tag <- @node.tags do %>
          <.link navigate={Routes.page_path(VegaWeb.Endpoint, :tag_detail, tag.slug)} class="badge">
            <%= tag.name %>
          </.link>
        <% end %>
      </p>
    <% end %>
    """
  end

  def node_content(%{node: %{type: "post"}, content: _content} = assigns) do
    ~H"""
    <%= raw(@content.body_html) %>
    """
  end

  def node_content(%{node: %{type: "image"} = _node, content: _content} = assigns) do
    ~H"""
    <%= if @content.rhash && @content.ext do %>
      <%= img_tag(
        "https://d2f33fmhbh7cs9.cloudfront.net/image/" <>
          @content.rhash <>
          "/960w/" <>
          to_string(@node.id) <>
          "." <>
          @content.ext,
        title: @node.title
      ) %>
    <% else %>
      <p>[missing]</p>
    <% end %>
    <%= raw(Earmark.as_html!(@content.description)) %>
    """
  end

  def node_content(%{node: %{type: "bookmark"} = _node, content: _content} = assigns) do
    ~H"""
    <p><.link navigate={@content.url}><%= @node.title %></.link></p>
    <%= raw(Earmark.as_html!(@content.description)) %>
    """
  end
end
