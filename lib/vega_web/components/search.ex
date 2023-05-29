defmodule VegaWeb.Components.Search do
  @moduledoc """
  Search Form
  """
  use Phoenix.Component
    
  def search(assigns) do
    ~H"""
    <form action="/search" method="get">
    <input type="text" name="q" class="input-xs text-slate-900" /><input type="submit" value="search" class="btn input-xs btn-xs"/>
    </form>
    """
  end
end      
