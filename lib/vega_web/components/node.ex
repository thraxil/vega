defmodule VegaWeb.Components.Node do
  @moduledoc """
  node title
  """
  use Phoenix.Component
  alias VegaWeb.Router.Helpers, as: Routes
  import Phoenix.HTML

  def node_link(assigns) do
    ~H"""
    <.link navigate={VegaWeb.PageView.node_path(@node)} class="text-slate-900">
      {@node.title}
    </.link>
    """
  end

  def node_title(assigns) do
    ~H"""
    <h2 class="text-3xl md:text-4xl font-extrabold tracking-tight text-slate-900 mb-2 mt-12 first:mt-0">
      <.link
        navigate={VegaWeb.PageView.node_path(@node)}
        class="hover:text-indigo-600 transition-colors"
      >
        {@node.title}
      </.link>
    </h2>
    """
  end

  def article(assigns) do
    ~H"""
    <article class="mb-16 md:mb-24">
      {render_slot(@inner_block)}
    </article>
    """
  end

  defp dformat_node(timestamp) do
    ~c"~4..0B-~2..0B-~2..0B"
    |> :io_lib.format([timestamp.year, timestamp.month, timestamp.day])
    |> List.to_string()
  end

  def byline(assigns) do
    ~H"""
    <p class="text-sm text-slate-500 mb-6">
      By
      <.link
        navigate={Routes.page_path(VegaWeb.Endpoint, :user_detail, @node.user.username)}
        class="font-medium text-slate-700 hover:text-indigo-600 transition-colors"
      >
        {@node.user.fullname}
      </.link>
      <span class="mx-1.5 text-slate-300">&bull;</span>
      <time datetime={NaiveDateTime.to_iso8601(@node.created)}>{dformat_node(@node.created)}</time>
    </p>
    """
  end

  def inline_byline(assigns) do
    ~H"""
    <span class="text-sm text-slate-500">
      By
      <.link
        navigate={Routes.page_path(VegaWeb.Endpoint, :user_detail, @node.user.username)}
        class="font-medium text-slate-700 hover:text-indigo-600 transition-colors"
      >
        {@node.user.fullname}
      </.link>
      <span class="mx-1.5 text-slate-300">&bull;</span>
      <time datetime={NaiveDateTime.to_iso8601(@node.created)}>{dformat_node(@node.created)}</time>
    </span>
    """
  end

  def node_tags(assigns) do
    ~H"""
    <%= if length(@node.tags) > 0 do %>
      <div class="mt-8 flex flex-wrap gap-2 items-center">
        <span class="text-sm text-slate-500 mr-2">Tags:</span>
        <%= for tag <- @node.tags do %>
          <.link
            navigate={Routes.page_path(VegaWeb.Endpoint, :tag_detail, tag.slug)}
            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-slate-100 text-slate-800 hover:bg-slate-200 transition-colors"
          >
            {tag.name}
          </.link>
        <% end %>
      </div>
    <% end %>
    """
  end

  def node_content(%{node: %{type: "post"}, content: _content} = assigns) do
    ~H"""
    <div class="prose prose-lg max-w-none">
      {raw(@content.body_html)}
    </div>
    """
  end

  def node_content(%{node: %{type: "image"} = _node, content: _content} = assigns) do
    ~H"""
    <figure class="my-8">
      <%= if @content.rhash && @content.ext do %>
        <img
          src={"https://d2f33fmhbh7cs9.cloudfront.net/image/" <> @content.rhash <> "/960w/" <> to_string(@node.id) <> "." <> @content.ext}
          title={@node.title}
          width="960"
          class="rounded-lg shadow-sm w-full h-auto"
        />
      <% else %>
        <div class="bg-slate-100 rounded-lg p-8 text-center text-slate-500 italic">
          [missing image]
        </div>
      <% end %>
      <%= if @content.description && @content.description != "" do %>
        <figcaption class="mt-4 prose max-w-none text-center">
          {raw(Earmark.as_html!(@content.description))}
        </figcaption>
      <% end %>
    </figure>
    """
  end

  def node_content(%{node: %{type: "bookmark"} = _node, content: _content} = assigns) do
    ~H"""
    <div class="bg-slate-50 border border-slate-100 rounded-lg p-6 my-6">
      <p class="font-medium text-lg mb-3">
        <.link
          navigate={@content.url}
          class="text-indigo-600 hover:text-indigo-800 flex items-center gap-1"
        >
          {@node.title}
          <svg
            class="w-4 h-4"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
            >
            </path>
          </svg>
        </.link>
      </p>
      <div class="prose max-w-none">
        {raw(Earmark.as_html!(@content.description))}
      </div>
    </div>
    """
  end
end
