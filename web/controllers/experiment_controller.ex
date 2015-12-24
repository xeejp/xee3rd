defmodule Xee3rd.ExperimentController do
  use Xee3rd.Web, :controller

  plug Xee3rd.AuthenticationPlug when action in [:host]

  def index(conn, %{"x_id" => x_id}) do
    if Xee3rd.ExperimentServer.has?(x_id) do
      u_id = case {get_session(conn, :u_id), get_session(conn, :x_id)} do
        {u_id, ^x_id} -> u_id
        _ ->
          u_id = Xee3rd.TokenGenerator.generate
          put_session(conn, :u_id, u_id)
          put_session(conn, :x_id, x_id)
          u_id
      end
      token = Xee3rd.TokenGenerator.generate
      Onetime.register(Xee3rd.participant_onetime, token, %{participant_id: u_id, experiment_id: x_id})
      render conn, "index.html", token: token, topic: x_id <> ":participant"
    else
      conn
      |> put_flash(:error, "Not Exists Experiment ID")
      |> redirect(to: "/")
    end
  end

  def host(conn, %{"x_id" => x_id}) do
    has = Xee3rd.HostServer.has?(get_session(conn, :current_user), x_id)
    if has do
      token = Xee3rd.TokenGenerator.generate
      Onetime.register(Xee3rd.host_onetime, token, %{host_id: conn.assigns[:host], experiment_id: x_id})
      render conn, "admin.html", token: token, topic: x_id <> ":host"
    else
      conn
      |> put_flash(:error, "Not Exists Experiment ID")
      |> redirect(to: "/host")
    end
  end
end
