defmodule Mix.Tasks.Compile.Chronos do
  use Mix.Task.Compiler

  @impl true
  def run(_args) do
    IO.puts("Recompiling project with instrumented code")
    Chronos.Injector.run()
    Mix.Task.rerun("compile.elixir", ["--force"])
  end
end
