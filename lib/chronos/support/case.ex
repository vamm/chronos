defmodule Chronos.Case do
  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case, async: false

      import Chronos.TestHelper
    end
  end
end
