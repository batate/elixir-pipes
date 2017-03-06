
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

  defmacro pipe_matching(test, pipes) do
    do_pipe_matching((quote do: expr), (quote do: unquote(test) = expr), pipes)
  end

  defmacro pipe_matching(expr, test, pipes) do
    do_pipe_matching(expr, test, pipes)
  end

  defp unpipe([do: pipes]), do: Macro.unpipe(pipes)
  defp unpipe(pipes), do: Macro.unpipe(pipes)

  defp do_pipe_matching(expr, test, pipes) do
    [{h,_}|t] = unpipe(pipes)
    Enum.reduce t, h, &(reduce_matching &1, &2, expr, test)
  end

  defp reduce_matching({x, pos}, acc, expr, test) do
    quote do
      case unquote(acc) do
        unquote(test) -> unquote(Macro.pipe(expr, x, pos))
        acc -> acc
      end
    end
  end

  #     pipe_while &(valid? &1),
  #     json_doc |> transform |> transform

  defmacro pipe_while(test, pipes) do
    [{h,_}|t] = unpipe(pipes)
    Enum.reduce t, h, &(reduce_if &1, &2, test)
  end

  defp reduce_if({x, pos}, acc, test) do
    quote do
      acc = unquote(acc)
      case unquote(test).(acc) do
        true  -> unquote(Macro.pipe((quote do: acc), x, pos))
        false -> acc
      end
    end
  end

  # a custom merge function that takes the piped function and an argument,
  # and returns the accumulated value
  # pipe_with fn(f, acc) -> Enum.map(acc, f) end,
  #   [ 1, 2, 3] |> &(&1 + 1) |> &(&1 * 2)

  defmacro pipe_with(fun, pipes) do
    [{h,_}|t] = unpipe(pipes)
    Enum.reduce t, h, &(reduce_with &1, &2, fun)
  end

  defp reduce_with({segment, pos}, acc, outer) do
    pipe = Macro.pipe((quote do: x), segment, pos)
    quote do
      unquote(outer).(unquote(acc), fn(x) -> unquote(pipe) end)
    end
  end

  # pipe with error-monad logic
  defmacro pipe_error_m(pipes) do
    [{h,_}|t] = Macro.unpipe(pipes)
    Enum.reduce t, h, &(reduce_matching &1, &2)
  end

  defp reduce_matching({x, pos}, acc) do
    quote do
      case unquote(acc) do
        {:ok, val} -> unquote(Macro.pipe((quote do: val), x, pos))
        {:error, reason} -> {:error, reason}
        val -> unquote(Macro.pipe((quote do: val), x, pos))
      end
    end
  end
end
