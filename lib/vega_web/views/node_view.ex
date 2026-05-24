defmodule VegaWeb.NodeView do
  use VegaWeb, :view

  def dformat_node(timestamp) do
    ~c"~4..0B-~2..0B-~2..0B"
    |> :io_lib.format([timestamp.year, timestamp.month, timestamp.day])
    |> List.to_string()
  end
end
