defmodule Hold.Coordinate do
  @moduledoc """
  A coordinate in an xy plane with (0,0) being the top left corner.
  """

  @type t :: {x :: integer(), y :: integer()}

  @spec new(x :: integer(), y :: integer()) :: t()
  @doc """
  Create a new Coordinate
  """
  def new(x, y) when is_integer(x) and is_integer(y) do
    {x, y}
  end

  @spec around(t()) :: [t(), ...]
  @doc """
  Return all surrounding coordinates.

  ```elixir
  iex> Hold.Coordinate.around({1, 1})
  [{1, 0}, {1, 2}, {2, 1}, {2, 0}, {2, 2}, {0, 1}, {0, 0}, {0, 2}]
  ```
  """
  def around({x, y}) do
    for x <- [x, x + 1, x - 1],
        y <- [y, y - 1, y + 1] do
      {x, y}
    end
    # filter out current coord
    |> Enum.reject(&match?({^x, ^y}, &1))
  end

  @spec up(t()) :: t()
  @doc """
  Return upward coordinate.

  ```elixir
  iex> Hold.Coordinate.up({0, 1})
  {-1, 1}
  ```
  """
  def up({x, y}) do
    {x - 1, y}
  end

  @spec right(t()) :: t()
  @doc """
  Return coordinate to the right

  ```elixir
  iex> Hold.Coordinate.right({1, 1})
  {1, 2}

  iex> Hold.Coordinate.right({0, -1})
  {0, 0}
  ```
  """
  def right({x, y}) do
    {x, y + 1}
  end

  @spec down(t()) :: t()
  @doc """
  Return downward coordinate.

  ```elixir
  iex> Hold.Coordinate.down({0, 1})
  {1, 1}

  iex> Hold.Coordinate.down({-1, 0})
  {0, 0}
  ```
  """
  def down({x, y}) do
    {x + 1, y}
  end

  @spec left(t()) :: t()
  @doc """
  Return coordinate to the left

  ```elixir
  iex> Hold.Coordinate.left({1, 1})
  {1, 0}

  iex> Hold.Coordinate.left({0, -1})
  {0, -2}
  ```
  """
  def left({x, y}) do
    {x, y - 1}
  end
end
