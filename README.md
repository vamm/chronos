# Chronos

Elixir code profiler through code instrumentation directly in your test suite.  

## Running

1. Add `chronos` to your `mix.exs` file:

```elixir
def deps do
  [
    {:chronos, "~> 0.1.0"}
  ]
end
```

2. Create a profiling test scenario:

```elixir
defmodule Example.ClientTest do
  use Chronos.Case

  test "retries requests at most 4 times" do
    assert %{{HTTP.Client, {:get, 1}} => 4} = Chronos.benchmark(fn ->
      Client.call("https://example.com/404")
    end)
  end
end
```

3. Run along with the test suit with `mix test`.
