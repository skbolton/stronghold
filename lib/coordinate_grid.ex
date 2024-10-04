defmodule Hold.CoordinateGrid do
  @moduledoc """
  A collection of values held at `Hold.Coordinate`s.
  """
  alias Hold.Coordinate

  @typedoc """
  User provided value being stored at `t:Hold.Corrdinate.t()` in `t:grid`.
  """
  @type value :: term()

  @typedoc """
  A representation of a valid `t:Hold.Coordinate.t` in `t` and `t:value` it is
  holding.
  """
  @type cell :: nil | {Coordinate.t(), value()}

  @typedoc """
  Representation of item at a `t:Hold.Coordinate.t` in `t`.
  """
  @opaque member(a) :: {:value, a} | nil
  @opaque member :: {:value, value()} | nil

  @opaque predicate :: (term -> boolean())

  @type t(a) :: %__MODULE__{g: %{Coordinate.t() => member(a)}}
  @type t :: %__MODULE__{g: %{Coordinate.t() => member()}}

  defstruct [:g]

  @spec new() :: t()
  @doc """
  Creates a new `CoordinateGrid`.

  ```elixir
  iex> Hold.CoordinateGrid.new()
  %Hold.CoordinateGrid{g: %{}}
  ```
  """
  def new() do
    %__MODULE__{g: %{}}
  end

  @spec add(t(), Coordinate.t(), value()) :: t()
  @doc """
  Add `value` to `grid` at `coord`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> Hold.CoordinateGrid.get(grid, {1, 1})
  {{1, 1}, :mine}

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> Hold.CoordinateGrid.get(grid, {10, 10})
  nil
  ```
  """
  def add(grid, coord, value) do
    %__MODULE__{
      g: Map.put(grid.g, coord, {:value, value})
    }
  end

  @spec get(t(), Coordinate.t()) :: cell()
  @doc """
  Get value of `grid` at `coord` returning nil in the case of an empty
  `t:cell`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> Hold.CoordinateGrid.get(grid, {1, 1})
  {{1, 1}, :mine}

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> Hold.CoordinateGrid.get(grid, {10, 10})
  nil
  ```
  """
  def get(grid, coord) do
    case Map.get(grid.g, coord) do
      nil -> nil
      {:value, value} -> {coord, value}
    end
  end

  @spec member?(t(), Coordinate.t()) :: boolean()
  @spec member?(t(), Coordinate.t(), predicate()) :: boolean()
  @doc """
  Return whether `t:coord` contains a `t:cell` in `grid`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> Hold.CoordinateGrid.member?(grid, {1, 1})
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> Hold.CoordinateGrid.member?(grid, {10, 10})
  false

  ```

  An optional predicate can be passed to further test found `t:cell`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> Hold.CoordinateGrid.member?(grid, {1, 1}, fn {_coord, value} -> value != :mine end)
  false
  ```
  """
  def member?(grid, coord, predicate \\ &always_true/1) do
    case get(grid, coord) do
      nil ->
        false

      cell ->
        apply(predicate, [cell])
    end
  end

  @spec neighbors(t(), Coordinate.t()) :: [cell()]
  @spec neighbors(t(), Coordinate.t(), predicate()) :: [cell()]
  @doc """
  Return list of immediate neighboring coordinates to `coord` members of `grid`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.neighbors(grid, {1, 1})
  [{{2, 1}, :mine}, {{1, 2}, :powerup}]
  ```

  An optional predicate function can be passed as an additional test on found
  neighbors.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.neighbors(grid, {1, 1}, fn {_coord, value} -> value == :mine end)
  [{{2, 1}, :mine}]
  ```
  """
  def neighbors(grid, coord, predicate \\ &always_true/1) do
    coord
    |> Hold.Coordinate.around()
    |> Enum.reduce([], fn coord, found_neighbors ->
      cell = get(grid, coord)

      cond do
        cell == nil -> found_neighbors
        apply(predicate, [cell]) -> [cell | found_neighbors]
        _failed_predicate = true -> found_neighbors
      end
    end)
  end

  @spec neighbors?(t(), Coordinate.t()) :: boolean()
  @spec neighbors?(t(), Coordinate.t(), predicate()) :: boolean()
  @doc """
  Check if `coord` has any neighbors who are members of `grid`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.neighbors?(grid, {1, 1})
  true
  ```

  An optional predicate function can be passed as an additional test on
  neighbors.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.neighbors?(grid, {1, 1}, fn {_coord, value} -> value == :mine end)
  false
  ```
  """
  def neighbors?(grid, coord, predicate \\ &always_true/1) do
    coord
    |> Coordinate.around()
    |> Enum.any?(fn coordinate ->
      case get(grid, coordinate) do
        nil -> false
        cell -> apply(predicate, [cell])
      end
    end)
  end

  @spec up?(t(), Coordinate.t()) :: boolean()
  @doc """
  Returns whether `grid` contains a coord to the upward from `coord`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :powerup)
  iex> Hold.CoordinateGrid.up?(grid, {1, 1})
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :powerup)
  iex> Hold.CoordinateGrid.up?(grid, {2, 1})
  false
  ```

  An optional predicate can be passed to further test found `t:cell`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :powerup)
  iex> Hold.CoordinateGrid.up?(grid, {1, 1}, fn {_coord, value} -> value == :mine end)
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :powerup)
  iex> Hold.CoordinateGrid.up?(grid, {1, 1}, fn {_coord, value} -> value != :mine end)
  false
  ```
  """
  def up?(grid, coord, predicate \\ &always_true/1) do
    case up(grid, coord) do
      nil ->
        false

      to_right ->
        apply(predicate, [to_right])
    end
  end

  @spec up(t(), Coordinate.t()) :: cell()
  @doc """
  Get cell upward of `coord` in `grid`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :powerup)
  iex> Hold.CoordinateGrid.up(grid, {1, 1})
  {{2, 1}, :mine}

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :powerup)
  iex> Hold.CoordinateGrid.up(grid, {2, 1})
  nil
  ```
  """
  def up(grid, coord) do
    get(grid, Coordinate.up(coord))
  end

  @spec right?(t(), Coordinate.t()) :: boolean()
  @doc """
  Returns whether `grid` contains a coord to the right of `coord`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.right?(grid, {1, 1})
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.right?(grid, {1, 2})
  false
  ```

  An optional predicate can be passed to further test found `t:cell`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.right?(grid, {1, 1}, fn {_coord, value} -> value == :powerup end)
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.right?(grid, {1, 1}, fn {_coord, value} -> value == :mine end)
  false
  ```
  """
  def right?(grid, coord, predicate \\ &always_true/1) do
    case right(grid, coord) do
      nil ->
        false

      to_right ->
        apply(predicate, [to_right])
    end
  end

  @spec right(t(), Coordinate.t()) :: cell()
  @doc """
  Returns whether `grid` contains a coord to the right from `coord`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.right(grid, {1, 1})
  {{1, 2}, :powerup}

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.right(grid, {1, 2})
  nil
  ```
  """
  def right(grid, coord) do
    get(grid, Coordinate.right(coord))
  end

  @spec down?(t(), Coordinate.t()) :: boolean()
  @spec down?(t(), Coordinate.t(), predicate()) :: boolean()
  @doc """
  Returns whether `grid` contains a coord to the downward from `coord`.

  An optional predicate function can be passed as an additional test on found
  value.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :powerup)
  iex> Hold.CoordinateGrid.down?(grid, {1, 1})
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :powerup)
  iex> Hold.CoordinateGrid.down?(grid, {2, 1})
  false
  ```

  An optional predicate can be passed to further test found `t:cell`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :powerup)
  iex> Hold.CoordinateGrid.down?(grid, {1, 1}, fn {_coord, value} -> value == :powerup end)
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :powerup)
  iex> Hold.CoordinateGrid.down?(grid, {1, 1}, fn {_coord, value} -> value == :mine end)
  false
  ```
  """
  def down?(grid, coord, predicate \\ &always_true/1) do
    case down(grid, coord) do
      nil ->
        false

      to_down ->
        apply(predicate, [to_down])
    end
  end

  @spec down(t(), Coordinate.t()) :: nil | value()
  @doc """
  Get value to downward from `coord` in `grid`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :powerup)
  iex> Hold.CoordinateGrid.down(grid, {1, 1})
  {{2, 1}, :powerup}

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {2, 1}, :powerup)
  iex> Hold.CoordinateGrid.right(grid, {2, 1})
  nil
  ```
  """
  def down(grid, coord) do
    get(grid, Coordinate.down(coord))
  end

  @spec left?(t(), Coordinate.t()) :: boolean()
  @spec left?(t(), Coordinate.t(), predicate()) :: boolean()
  @doc """
  Returns whether `grid` contains a coord to the immediate left of `coord`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.left?(grid, {1, 2})
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.left?(grid, {1, 1})
  false
  ```

  An optional predicate can be passed to further test found `t:cell`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.left?(grid, {1, 2}, fn {_coord, value} -> value == :mine end)
  true

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.left?(grid, {1, 2}, fn {_coord, value} -> value != :mine end)
  false
  ```
  """
  def left?(grid, coord, predicate \\ &always_true/1) do
    case left(grid, coord) do
      nil ->
        false

      to_left ->
        apply(predicate, [to_left])
    end
  end

  @spec left(t(), Coordinate.t()) :: cell()
  @doc """
  Get value to left of `coord` in `grid`.

  ```elixir
  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.left(grid, {1, 2})
  {{1, 1}, :mine}

  iex> grid = Hold.CoordinateGrid.new()
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 1}, :mine)
  iex> grid = Hold.CoordinateGrid.add(grid, {1, 2}, :powerup)
  iex> Hold.CoordinateGrid.left(grid, {1, 1})
  nil
  ```
  """
  def left(grid, coord) do
    get(grid, Coordinate.left(coord))
  end

  @spec traverse(
          t(),
          coord :: Coordinate.t(),
          acc :: term(),
          iterator :: (cell(), acc :: term() -> {:cont, Coordinate.t(), term()} | {:halt, term()})
        ) :: term()
  @doc """
  Traverse over grid starting at `coord` collecting an accumulator value.

  `iterator` function should return either `{:cont, next_coordinate, acc}` to
  step to next coordinate, or `{:halt, acc}` to return accumulator and stop
  traversal.
  """
  def traverse(grid, coordinate, acc, iterator) do
    case iterator.(get(grid, coordinate), acc) do
      {:cont, next_coord, next_acc} -> traverse(grid, next_coord, next_acc, iterator)
      {:halt, acc} -> acc
    end
  end

  defp always_true(_value), do: true

  defimpl Enumerable do
    def count(grid) do
      {:ok, Kernel.map_size(grid.g)}
    end

    def slice(_grid) do
      {:error, __MODULE__}
    end

    def reduce(grid, acc, fun) do
      grid.g
      |> :maps.to_list()
      |> Enum.map(fn {coord, {:value, value}} -> {coord, value} end)
      |> Enumerable.List.reduce(acc, fun)
    end

    def member?(grid, {coordinate, _value}) do
      {:ok, Hold.CoordinateGrid.get(grid, coordinate) != nil}
    end
  end

  defimpl Collectable do
    def into(grid) do
      collector_function = fn
        grid_acc, {:cont, {coord, value}} ->
          Hold.CoordinateGrid.add(grid_acc, coord, value)

        grid_acc, :done ->
          grid_acc

        _map_set_acc, :halt ->
          :ok
      end

      {grid, collector_function}
    end
  end
end
