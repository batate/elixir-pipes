
defmodule Pipe do
  defmacro __using__(_) do
    quote do
      require Pipe
      import Pipe
    
    end
  end
  
  
  #     pipe_matching { :ok, _ }, x,
  #        ensure_protocol(protocol)
  #     |> change_debug_info(types)
  #     |> compile
  
  defmacro pipe_matching(expr, pipes) do
    quote do
      pipe_if(&(match? unquote(expr), &1), unquote pipes)
    end
  end

  defmacro pipe_if(test, pipes) do
    Enum.reduce Macro.unpipe(pipes), fn x, acc ->
      left_side = quote do: ac
      quote do
        ac = unquote acc
        case unquote(test).(ac) do
          true -> unquote(Macro.pipe(left_side, x))
          false -> ac
        end
      end
    end
  end

  # pipe :matching, {:ok, _}, 
  #        ensure_protocol(protocol)
  #     |> change_debug_info(types)
  #     |> compile
  defmacro pipe(form, arg, pipes) do
    case form do
      :matching -> pipe_matching(arg, pipes)
      :if -> pipe_if(arg, pipes)
      other -> raise "Unsupported pipe form: #{form}"
    end
  end
    

  defmacro show_pipes(pipes) do
    IO.puts inspect(Macro.unpipe(pipes))
  end

  
  
end