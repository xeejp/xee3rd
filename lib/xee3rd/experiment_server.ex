defmodule Xee3rd.ExperimentServer do
  def start_link() do
    Agent.start_link(fn -> %{} end)
  end

  @doc "Checks whether the key is used."
  def has?(key) do
    Agent.get(__MODULE__, fn map -> Map.has_key?(map, key) end)
  end

  @doc "Creates and Register a experiment."
  def create(key, experiment) do
    {:ok, uid} = Experiment.start(experiment)
    Agent.update(__MODULE__, fn map -> Map.put(map, key, uid) end)
    uid
  end

  @doc "Returns the experiments' map."
  def get_all() do
    Agent.get(__MODULE__, fn map -> map end)
  end

  @doc "Returns the experiment."
  def get(key) do
    Agent.get(__MODULE__, fn map -> map[key] end)
  end

  @doc "Removes the experiment."
  def remove(key) do
    Agent.update(__MODULE__, fn map -> Map.delete(map, key) end)
  end
end
