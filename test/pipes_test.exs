defmodule PipesTest do
  import Should
  use ExUnit.Case

  defmodule Simple do
    use Pipe
    def inc(x), do: x + 1
    def double(x), do: x * 2

    def triple(x, y), do: x * y
    def pipes, do: 1 |> inc |> double
    def with_pipes_identity do
      pipe_with fn(acc, f) -> f.(acc) end,
        [ 1, 2, 3] |> Enum.map( &( &1 - 2 ) ) |> Enum.map( &( &1 * 2 ) )
    end

    def with_pipes_map do
      pipe_with fn(acc, f) -> Enum.map(acc, f) end,
        [ 1, 2, 3] |> inc |> double
    end
  end

  defmodule Matching do
    use Pipe
    def if_test({:ok, _}), do: true
    def if_test(_), do: false
    def inc({code, x}), do: {code, x + 1}
    def double({code, x}), do: {code, x * 2}
    def ok_inc(x), do: {:ok, x + 1}
    def ok_double(x), do: {:ok, x * 2}
    def pipes, do: pipe_matching({:ok, _}, {:ok, 1} |> inc |> double )
    def do_pipes do
      pipe_matching {:ok, _} do
        {:ok, 1} |> inc |> double
      end
    end
    def if_pipes, do: pipe_while(&if_test/1, {:ok, 1} |> inc |> double )
    def pipes_expr, do: pipe_matching(x, {:ok, x}, {:ok, 1} |> ok_inc |> ok_double )
  end


  should "compose with identity function" do
    assert [-2, 0, 2] == Simple.with_pipes_identity
  end

  should "compose with map function" do
    assert [4, 6, 8] == Simple.with_pipes_map
  end

  should "pipe correctly" do
    assert  4 == Simple.pipes
  end

  should "pipe matching" do
    assert  {:ok, 4} == Matching.pipes
    assert  {:ok, 4} == Matching.pipes_expr
  end

  should "pipe do" do
    assert  {:ok, 4} == Matching.do_pipes
  end

  should "pipe if" do
    assert  {:ok, 4} == Matching.if_pipes
  end
end
