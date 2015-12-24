defmodule Xee3rd.PageControllerTest do
  use Xee3rd.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert conn.status == 200
  end
end
