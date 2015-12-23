defmodule Xee3rd.HostServer do
  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def register(host_id, experiment_info) do
    Agent.update(__MODULE__, fn map ->
      (
      list = if Map.has_key?(map, host_id), do: map[host_id], else: []
      Map.put(map, host_id, List.insert_at(list, 0, experiment_info))
      ) end)
  end

  def get(host_id) do
    Agent.get(__MODULE__, fn map ->
      map[host_id]
    end)
  end

  def drop(host_id) do
    Agent.update(__MODULE__, fn map ->
      Map.delete(map, host_id)
    end)
  end
end
