defmodule VegaWeb.Components.Search do
  @moduledoc """
  Search Form
  """
  use Phoenix.Component

  def search(assigns) do
    ~H"""
    <form action="/search" method="get" class="relative flex items-center">
      <div class="relative w-full max-w-xs">
        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
          <svg
            class="h-4 w-4 text-slate-400"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path
              fill-rule="evenodd"
              d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <input
          type="search"
          name="q"
          id="search"
          class="block w-full pl-9 pr-3 py-1.5 border border-slate-300/80 rounded-md leading-5 bg-white/80 backdrop-blur-sm placeholder-slate-600 text-slate-900 focus:outline-none focus:bg-white focus:placeholder-slate-400 focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition duration-150 ease-in-out shadow-sm"
          placeholder="Search..."
        />
      </div>
    </form>
    """
  end
end
