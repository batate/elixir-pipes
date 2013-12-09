defmodule Should do
  defmacro should(name, options) do
    quote do
      test("should #{unquote name}", unquote(options))
    end
  end
end

ExUnit.start
