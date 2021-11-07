defmodule Chronos.Application do
  use Application

  def start(_type, _args) do
    if Mix.env() == :test do
      Mix.Task.run("compile.chronos", [])
      start_children()
    else
      :ok
    end
  end

  defp start_children do
    children = [Chronos.Collector]
    Supervisor.start_link(children, strategy: :one_for_one, name: Chronos.Supervisor)
  end
end
