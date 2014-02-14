
defmodule Pipe do
  @moduledoc """
  def inc(x), do: x + 1
  def double(x), do: x * 2
  
  1 |> inc |> double
  """
  defmacro __using__(_) do
    quote do
      import Pipe
    end
  end
  
  
  #     pipe_matching { :ok, _ }, x,
  #        ensure_protocol(protocol)
  #     |> change_debug_info(types)
  #     |> compile
  
  defmacro pipe_matching(expr, pipes) do
    quote do
      pipe_while(&(match? unquote(expr), &1), unquote pipes)
    end
  end

  #     pipe_while &(valid? &1), 
  #     json_doc |> transform |> transform

  defmacro pipe_while(test, pipes) do
    Enum.reduce Macro.unpipe(pipes), &(reduce_if &1, &2, test)
  end
  
  defp reduce_if( x, acc, test ) do
    left_side = quote do: ac
    
    quote do
      ac = unquote acc
      case unquote(test).(ac) do
        true -> unquote(Macro.pipe(left_side, x))
        false -> ac
      end
    end
  end
  
  
  # a custom merge function that takes the piped function and an argument, 
  # and returns the accumulated value
  # pipe_with fn(f, acc) -> Enum.map(acc, f) end,
  #   [ 1, 2, 3] |> &(&1 + 1) |> &(&1 * 2)
  
  defmacro pipe_with(fun, pipes) do
    Enum.reduce Macro.unpipe(pipes), &(reduce_with &1, &2, fun)
  end

  defp reduce_with( segment, acc, outer ) do
    x = quote do: x
    quote do
      inner = fn(x) ->
        unquote Macro.pipe(x, segment)
      end

      unquote(outer).(unquote(acc), inner)
    end
  end
  
  
end