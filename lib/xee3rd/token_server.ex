defmodule Xee3rd.TokenServer do
  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc "Check whether the token is used."
  def has?(token) do
    Agent.get(__MODULE__, fn map -> Map.has_key?(token) end)
  end

  @doc "Returns the experiment id."
  def get(token) do
    Agent.get(__MODULE__, fn map -> map[token] end)
  end

  @doc "Registers an experiment id."
  def register(token, experiment_id) do
    Agent.update(__MODULE__, fn map -> Map.put(map, token, experiment_id) end)
  end

  @doc "Drops the token."
  def drop(token) do
    Agent.update(__MODULE__, fn map -> Map.delete(map, token) end)
  end

  @doc "Changes the token."
  def change(token, new_token) do
    Agent.update(__MODULE__, fn map ->
      (
      experiment = map[token]
      map
      |> Map.delete(token)
      |> Map.put(new_token, experiment)
      ) end)
  end
end
