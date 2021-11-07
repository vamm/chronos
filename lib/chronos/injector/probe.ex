defmodule Chronos.Injector.Probe do
  def hook(%{module: module} = _env, _kind, _name, _args, _guards, _body) do
    if :ets.lookup(:chronos, module) == [] and injectable?(module) do
      inject(module)
    end
  end

  defp inject(module) do
    {_set, bag} = :elixir_module.data_tables(module)

    bag
    |> :ets.tab2list()
    |> Enum.each(&instrument(bag, module, &1))

    :ets.insert(:chronos, {module, true})
    IO.puts("Hooked definitions into #{module}")
  end

  defp instrument(bag, module, {{:clauses, {_function_name, _arity} = signature} = key, ast}) do
    instrumented_ast = Chronos.Instrumentor.run(ast, {module, signature})

    IO.inspect(instrumented_ast)

    :ets.delete(bag, key)
    :ets.insert(bag, {key, instrumented_ast})
  end

  defp instrument(_bag, _module, _clauses), do: nil

  defp injectable?(Chronos.Injector), do: false
  defp injectable?(Chronos.Injector.Probe), do: false
  defp injectable?(Chronos.Collector), do: false
  defp injectable?(Chronos.Instrumentor), do: false
  defp injectable?(Chronos.TestHelper), do: false
  defp injectable?(Chronos.Case), do: false
  defp injectable?(_), do: true
end
