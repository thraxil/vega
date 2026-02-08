defmodule VegaWeb.Plugs.CachePlugTest do
  use VegaWeb.ConnCase, async: true

  alias VegaWeb.Plugs.CachePlug

  # The router pipeline where the plug is added sets a default cache-control header.
  # We need to remove it to properly test the plug.
  defp conn_without_default_cache_header(conn) do
    %{conn | resp_headers: List.keydelete(conn.resp_headers, "cache-control", 0)}
  end

  defp run_before_send_callbacks(conn) do
    Enum.reduce_while(conn.private[:before_send], conn, fn fun, acc ->
      case fun.(acc) do
        %Plug.Conn{halted: true} = halted_conn -> {:halt, halted_conn}
        %Plug.Conn{} = new_conn -> {:cont, new_conn}
      end
    end)
  end

  test "GET request for non-logged-in user has cache headers", %{conn: conn} do
    conn =
      conn_without_default_cache_header(conn)
      |> assign(:current_user, nil)

    conn = CachePlug.call(conn, [])
    conn = send_resp(conn, 200, "response body")

    assert get_resp_header(conn, "cache-control") == ["public, max-age=3600"]
    assert get_resp_header(conn, "etag") != []
  end

  test "GET request for logged-in user does not have cache headers", %{conn: conn} do
    user = %{id: 1, name: "test"}

    conn =
      conn_without_default_cache_header(conn)
      |> assign(:current_user, user)

    conn = CachePlug.call(conn, [])
    conn = send_resp(conn, 200, "response body")

    assert get_resp_header(conn, "cache-control") == []
    assert get_resp_header(conn, "etag") == []
  end

  test "non-GET request does not have cache headers", %{conn: conn} do
    conn =
      %{conn_without_default_cache_header(conn) | method: "POST"}
      |> assign(:current_user, nil)

    conn = CachePlug.call(conn, [])
    conn = send_resp(conn, 200, "response body")

    assert get_resp_header(conn, "cache-control") == []
    assert get_resp_header(conn, "etag") == []
  end

  test "GET request with matching if-none-match header returns 304", %{conn: conn} do
    conn =
      conn_without_default_cache_header(conn)
      |> assign(:current_user, nil)

    # First, get the ETag by simulating a response.
    conn_for_etag = send_resp(CachePlug.call(conn, []), 200, "response body")
    [etag] = get_resp_header(conn_for_etag, "etag")

    # Now, make a new request with the If-None-Match header
    conn =
      conn
      |> put_req_header("if-none-match", etag)

    # call the plug and simulate the response being sent
    conn = CachePlug.call(conn, [])
    conn = %{conn | resp_body: "response body", status: 200}
    conn = run_before_send_callbacks(conn)

    assert conn.status == 304
    assert conn.resp_body == ""
  end
end
