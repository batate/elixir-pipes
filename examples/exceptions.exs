defmodule ExceptionWrapper do
  @moduledoc """
  pipe_with is useful for handling exceptions. 
  
  In this case, we pipe with an exception handler so we can fold
  exceptions into a wrapper so we can handle exceptions with 
  a more uniform API. 
  """
  
  def wrap({:error, e, acc}, f), do: {:error, e, acc}
  def wrap(acc, f) do
    f.(acc)
  rescue
    x in [RuntimeError] ->
      {:error, x, acc}
  end
end

defmodule Roulette do
  def start, do: :ok
  def click(acc) do
    IO.puts "oh yayz iz a liv #{inspect acc}"
  end
  
  def bang(acc) do
    IO.puts "oh noz iz ded"
    raise "shotz"
  end
end

use Pipe
game = pipe_with &ExceptionWrapper.wrap/2, 
          Roulette.start |>
          Roulette.click |> 
          Roulette.click |> 
          Roulette.bang |> 
          Roulette.click

case game do
  {:error, e, _} -> IO.puts( "Player died with code: #{e.message}" )
  :ok -> IO.puts( "Player one won" )
end

