defmodule Xee3rd do
  use Application

  @host_onetime_server_name :HostOnetime
  @participant_onetime_server_name :ParticipantOnetime

  def host_onetime, do: @host_onetime_server_name
  def participant_onetime, do: @participant_onetime_server_name

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Xee3rd.Endpoint, []),
      # Start the Ecto repository
      worker(Xee3rd.Repo, []),
      worker(Xee3rd.ThemeServer, []),
      worker(Onetime, [[name: @host_onetime_server_name]]),
      worker(Onetime, [[name: @participant_onetime_server_name]], id: :participant),
      # Here you could define other workers and supervisors as children
      # worker(Xee3rd.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Xee3rd.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Xee3rd.Endpoint.config_change(changed, removed)
    :ok
  end
end
