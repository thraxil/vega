defmodule VegaWeb.Components.Node do
  @moduledoc """
  node title
  """
  use Phoenix.Component
  alias VegaWeb.Router.Helpers, as: Routes
  import Phoenix.HTML.{Link}
    
  def node_title(%{node: node} = assigns) do
    ~H"""
    <h2 class="bg-slate-300 my-0 "><%= link(node.title, to: VegaWeb.PageView.node_path(node),
    class: "no-underline text-slate-900 ") %></h2>
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

  def dformat_node(timestamp) do
    '~2..0B ~ts ~4..0B'
    |> :io_lib.format([timestamp.day, @months[timestamp.month], timestamp.year])
    |> List.to_string()
  end
  
  def byline(%{node: node} = assigns) do

    ~H"""
    <p class="bg-slate-100 my-0">By <%= link(node.user.fullname, to:
    Routes.page_path(VegaWeb.Endpoint, :user_detail, node.user.username),
    class: "text-slate-900") %> <%= dformat_node(node.created) %></p>
    """
  end
end
