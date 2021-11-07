defmodule Chronos.Injector do
  @probe_module Chronos.Injector.Probe

  def run do
    :ets.new(:chronos, [:named_table, :public])
    spawn(fn -> loop([]) end)
  end

  defp loop(seen_modules) do
    case :ets.tab2list(:elixir_modules) do
      [] ->
        # Mix.Compilers.Elixir will exists as long the compilation is running
        unless length(seen_modules) > 0 and is_nil(Process.get(Mix.Compilers.Elixir)) do
          loop(seen_modules)
        end

      [_ | _] = modules ->
        seen_modules = inject(modules, seen_modules) ++ seen_modules
        loop(seen_modules)
    end
  end

  defp inject(modules, seen_modules) do
    Enum.map(modules, fn
      {@probe_module, _, _, _, _} ->
        nil

      {module, {_set, bag}, _, _source, _} ->
        unless module in seen_modules do
          IO.puts("Injected @on_definition into #{module}")

          :ets.insert(
            bag,
            {{:accumulate, :on_definition}, {@probe_module, :hook}}
          )

          module
        end
    end)
  end
end
