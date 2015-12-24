defmodule Xee3rd.ThemeServer do
  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add(key, theme) do
    Agent.update(__MODULE__, fn map -> Map.put(map, key, theme) end)
  end

  def get_all() do
    Agent.get(__MODULE__, fn map -> map end)
  end

  def get(key) do
    Agent.get(__MODULE__, fn map -> map[key] end)
  end
end
