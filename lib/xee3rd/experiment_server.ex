defmodule Xee3rd.ExperimentServer do

  def start_link() do
    Agent.start_link(fn -> %{} end)
  end

  def add(uid, key, experiment) do
    Agent.update(uid, fn map -> Map.put(map, key, experiment) end)
  end

  def get_all(uid) do
    Agent.get(uid, fn map -> map end)
  end

  def get(uid, key) do
    Agent.get(uid, fn map -> map[key] end)
  end

  def change_key(uid, src, dest) do
    Agent.update(uid, fn map ->
      if Map.has_key?(map, src) && !Map.has_key?(map, dest) do
        tmp = map[src]
        map
        |> Map.delete(src)
        |> Map.put(dest, tmp)
      else
        map
      end
    end)
  end

end
