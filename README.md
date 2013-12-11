# elixir-pipes

Elixir Pipes is an [Elixir](https://github.com/elixir-lang/elixir/) extension that extends the pipe (|>) operator through macros. 

## The Pipe: Elixir Flavor Packet

Some of the [best](http://joearms.github.io/2013/05/31/a-week-with-elixir.html) [programmers](http://pragprog.com/book/elixir/programming-elixir) who have taken an early dive into Elixir have mentioned the pipe as one of the key features of the language. It allows a clear, concise expression of the programmer's intent: 

```elixir
  def inc(x), do: x + 1
  def double(x), do: x * 2
  
  1 |> inc |> double
```

The return value of each function is used as the first argument of the next function in the pipe. It's a beautiful expression that makes the intent of the programmer clear. 

## Problems
