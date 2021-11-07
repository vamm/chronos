defmodule Chronos.Instrumentor do
  def run({metadata, params, guards, {:__block__, [], parameters}}, signature) do
    {metadata, params, guards, {:__block__, [], instrument_calls(parameters, signature)}}
  end

  def run(
        {metadata, params, guards,
         {_inner_function, _inner_metadata, _inner_parameters} = single_call},
        signature
      ) do
    {metadata, params, guards, {:__block__, [], instrument_calls([single_call], signature)}}
  end

  def run(ast, _signature) do
    ast
  end

  defp instrument_calls(list, signature) do
    inspect_call = {{:., [], [Chronos.Collector, :trace]}, [], [signature]}

    [inspect_call | list]
  end
end
