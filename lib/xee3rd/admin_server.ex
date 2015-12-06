defmodule Xee3rd.AdminServer do
  alias Xee3rd.ExperimentServer, as: ExServer

  defmodule Admin, do: defstruct experiment_server: nil

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def create_experiment(key, experiment_id, experiment) do
    Agent.update(__MODULE__, fn map ->
      if Map.has_key?(map, key) do
        ExServer.add(map[key].experiment_server, experiment_id, experiment)
        map
      else
        {:ok, exs} = ExServer.start_link()
        value = %Admin{experiment_server: exs}
        ExServer.add(value.experiment_server, experiment_id, experiment)
        Map.put(map, key, value)
      end
    end)
  end

  def change_experiment_key(key, source, dest) do
    Agent.get(__MODULE__, fn map ->
      ExServer.change_key(map[key].experiment_server, source, dest)
    end)
  end

  def get_all(key) do
    Agent.get(__MODULE__, fn map -> ExServer.get_all(map[key].experiment_server) end)
  end
end
