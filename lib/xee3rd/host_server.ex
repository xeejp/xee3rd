defmodule Xee3rd.HostServer do
  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def register(host_id, experiment_id) do
    Agent.update(__MODULE__, fn map ->
      (
      list = if Map.has_key?(map, host_id), do: map[host_id], else: []
      Map.put(map, host_id, List.insert_at(list, 0, experiment_id))
      ) end)
  end

  @doc "Get all of experiments created by the host."
  def get(host_id) do
    Agent.get(__MODULE__, fn map ->
      map[host_id]
    end)
  end

  @doc "Check whether x_id exists or not."
  def has?(host_id, x_id) do
    Agent.get(__MODULE__, fn map -> Enum.member?(map[host_id], x_id) end)
  end

  @doc "Remove the experiment_id."
  def drop(host_id, x_id) do
    Agent.update(__MODULE__, fn map ->
      if Enum.member?(map, host_id) do
        Map.put(map, host_id, Enum.filter(map[host_id], fn x -> x != x_id end))
      else
        map
      end
    end)
  end
end
