defmodule PipesTest do
  import Should
  use ExUnit.Case
  
  defmodule Simple do
    use Pipe
    def inc(x), do: x + 1
    def double(x), do: x * 2
    def pipes, do: 1 |> inc |> double
  end
  
  defmodule Matching do
    use Pipe
    def if_test({:ok, _}), do: true
    def if_test(_), do: false
    def inc({code, x}), do: {code, x + 1}
    def double({code, x}), do: {code, x * 2}
    def pipes, do: pipe_matching({:ok, _}, {:ok, 1} |> inc |> double )
    def if_pipes, do: pipe_if(&if_test/1, {:ok, 1} |> inc |> double )
  end
  
  should "pipe correctly" do
    assert  4 == Simple.pipes
  end
  
  should "pipe while ok" do
    assert  {:ok, 4} == Matching.pipes
  end
  
  should "pipe if" do
    assert  {:ok, 4} == Matching.if_pipes
  end
  
end
