defmodule Chronos.TestHelper do
  def profile(function) do
    Chronos.Collector.clear()
    function.()
    Chronos.Collector.collect()
  end
end
