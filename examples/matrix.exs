defmodule Matrix do
  @moduledoc """
  pipe_with
  
  Basic matrix math. 
  
  matrix + 1 should add 1 to all cells of the matrix
  
  mix run examples/matrix.exs
  """
  # usage: 
  # matrix = [[1, 2], [2, 3], [0, 1]]
  # pipe_with &Matrix.merge_lists/2, matrix |> Kernel.+(1) |> Kernel.*(2)  
  # -> [[4, 6], [6, 8], [2, 4]]
  def merge_list(x, f), do: Enum.map(x, f)
  def merge_lists(x, f), do: Enum.map(x, &Matrix.merge_list(&1, f))

end

use Pipe
list = [1, 2, 3]
IO.inspect pipe_with &Matrix.merge_list/2, 
           list |> 
           Kernel.+(1) |> 
           Kernel.*(2)

matrix = [[1, 2], [2, 3], [0, 1]]
IO.inspect pipe_with &Matrix.merge_lists/2, 
           matrix |> 
           Kernel.+(1) |> 
           Kernel.*(2)

