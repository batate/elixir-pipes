defmodule RussianRoulette do
  def click(acc) do
    IO.puts "click..."
    {:ok, "click"}
  end

  def bang(acc) do
    IO.puts "BANG."
    {:error, "bang"}
  end
end

use Pipe

pipe_matching {:ok, _},  
{:ok, ""} |> 
RussianRoulette.click |> 
RussianRoulette.click |> 
RussianRoulette.bang |> 
RussianRoulette.click