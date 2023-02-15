defmodule VegaWeb.PageView do
  use VegaWeb, :view

  def node_year(node) do
    to_string(node.created.year) |> String.pad_leading(4, "0")
  end

  def node_month(node) do
    to_string(node.created.month) |> String.pad_leading(2, "0")
  end

  def node_day(node) do
    to_string(node.created.day) |> String.pad_leading(2, "0")
  end

  def node_path(node) do
    "/users/" <>
      node.user.username <>
      "/" <>
      node.type <>
      "s/" <>
      node_year(node) <>
      "/" <>
      node_month(node) <>
      "/" <>
      node_day(node) <>
      "/" <>
      node.slug
  end

  def user_path(user) do
    "/users/" <> user.username <> "/"
  end

  @months %{1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr",
            5 => "May", 6 => "Jun", 7 => "Jul", 8 => "Aug",
            9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec"}

  def dformat(timestamp) do
    '~2..0B ~ts ~4..0B'
    |> :io_lib.format([timestamp.day, @months[timestamp.month], timestamp.year])
    |> List.to_string
  end

end
