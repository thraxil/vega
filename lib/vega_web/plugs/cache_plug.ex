defmodule VegaWeb.Plugs.CachePlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.method == "GET" && !conn.assigns[:current_user] do
      register_before_send(conn, &add_cache_headers/1)
    else
      conn
    end
  end

  def add_cache_headers(conn) do
    if conn.status == 200 && conn.resp_body do
      conn
      |> put_resp_header("cache-control", "public, max-age=3600")
      |> generate_and_check_etag()
    else
      conn
    end
  end

  defp generate_and_check_etag(conn) do
    binary_body = IO.iodata_to_binary(conn.resp_body)
    etag = :crypto.hash(:sha256, binary_body) |> Base.encode64()

    if get_req_header(conn, "if-none-match") == ["\"#{etag}\""] do
      conn
      |> send_resp(304, "")
      |> halt()
    else
      put_resp_header(conn, "etag", "\"#{etag}\"")
    end
  end
end
