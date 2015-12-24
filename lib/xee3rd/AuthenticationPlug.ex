 defmodule Xee3rd.AuthenticationPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _default) do
    logged_in = Xee3rd.Session.logged_in?(conn)
    if logged_in do
      conn |> assign(:host, logged_in)
    else
      conn
      |> put_flash(:error, "You need to be signed in to view this page")
      |> redirect(to: "/login")
    end
  end
end
