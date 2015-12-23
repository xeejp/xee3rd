defmodule Xee3rd.Experiment do
  use GenServer

  def start_link(experiment) do
    GenServer.start_link(__MODULE__, experiment)
  end

  def init(experiment) do
    # TODO Start the interval server
    # Initialize the experiment.
   case call_script(experiment.script, ["init"]) do
    {0, result} -> {:ok, {experiment, result}}
    _ -> :error
   end
  end

  def fetch(pid) do
    GenServer.call(pid, :fetch)
  end

  def join(pid, id) do
    GenServer.cast(pid, {:script, ["join", id]})
  end

  def input(pid, input) do
    GenServer.cast(pid, {:script, ["input", input]})
  end

  def handle_call(:fetch, _from, state = {_experiment, data}) do
    {:reply, data, state}
  end

  def handle_cast({:script, list}, state = {experiment, data}) do
    [command | args] = experiment.script
    args = args ++ List.insert_at(list, 1, data)
    # command: "python"
    # args: ["script.py", "join", DATA, id]
    case call_script(command, args) do
      {0, result} ->
        # TODO Check whether data was changed or not and broadcast.
        {:noreply, {experiment, result}}
      _ -> {:stop, "The script failed.", state}
    end
  end

  @doc "Triggers interval events at fixed interval."
  defp interval(pid) do
    # TODO
    GenServer.cast(pid, {:script, ["update"]})
  end

  @doc "Calls the script with args."
  defp call_script(command, args) do
    {output, status} = System.cmd(command, args)
    {status, output}
  end
end
