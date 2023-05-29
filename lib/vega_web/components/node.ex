defmodule VegaWeb.Components.Node do
  @moduledoc """
  node title
  """
  use Phoenix.Component
  import Phoenix.HTML.{Link}
    
  def node_title(%{node: node} = assigns) do
    ~H"""
    <h2 class="bg-slate-300 my-0 "><%= link(node.title, to: VegaWeb.PageView.node_path(node),
    class: "no-underline text-slate-900 ") %></h2>
    """
  end
end
