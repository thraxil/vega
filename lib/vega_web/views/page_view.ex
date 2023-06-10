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
end
