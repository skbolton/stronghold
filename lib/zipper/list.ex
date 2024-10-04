defmodule Hold.Zipper.List do
  @moduledoc """
  An implementation of a Zipper over a list

  Introductory Article: https://ferd.ca/yet-another-article-on-zippers.html

  Supports being able to traverse a list both forwards and backwards while
  maintaining a focus on the current element much like a doubly-linked list.
  All while using functional immutable data structures and supporting O(1)
  lookup and traversal from focus.

  So given the list `[1, 2, 3, 4, 5]` we can imagine being able to "stop" on 3
  and then backtrack or keep progressing forward.

  ```
      (3)
    2     4
  1         5
  ```

  Zipper.List also supports θ(1) updating the currently focused item.
  """

  @typedoc """
  `left` represents items to the left of the focus. `right` is a list where the
  head of it is the current focus and the rest is the items to the right of
  focus.
  """
  @type t(a) :: {left :: [a], right :: [a]}
  @type t :: {left :: [term()], right :: [term()]}

  @type invalid_move :: {:error, :invalid_move}

  @spec from_list(list()) :: t()
  def from_list([_at_least_one_item | _rest] = list) do
    {_left = [], _right = list}
  end

  @spec to_list(t(term())) :: [term()]
  def to_list({left, right}) do
    left
    |> Enum.reverse()
    |> Enum.concat(right)
  end

  @spec right(t()) :: {:ok, t()} | Hold.Zipper.invalid_move()
  @doc """
  Move focus right, if possible.

  ```elixir
  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> {:ok, zipper} = Hold.Zipper.List.right(zipper)
  iex> Hold.Zipper.List.focus(zipper)
  2

  iex> zipper = Hold.Zipper.List.from_list([1])
  iex> Hold.Zipper.List.right(zipper)
  {:error, :invalid_move}
  ```
  """
  def right({_left, [_focus]}), do: {:error, :invalid_move}

  def right({left, [old_focus | right]}) do
    {:ok, {[old_focus | left], right}}
  end

  @spec right?(t()) :: boolean()
  @doc """
  Return whether an element to the right exists.

  ```elixir
  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> Hold.Zipper.List.right?(zipper)
  true

  iex> zipper = Hold.Zipper.List.from_list([1])
  iex> Hold.Zipper.List.right?(zipper)
  false
  ```
  """
  def right?({_left, [_focus]}), do: false
  def right?({_left, [_focus | _rest]}), do: true

  @spec left(t()) :: {:ok, t()} | Hold.Zipper.invalid_move()
  @doc """
  Move focus left, if possible.

  ```elixir
  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> {:ok, zipper} = Hold.Zipper.List.right(zipper)
  iex> {:ok, zipper} = Hold.Zipper.List.left(zipper)
  iex> Hold.Zipper.List.focus(zipper)
  1

  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> Hold.Zipper.List.left(zipper)
  {:error, :invalid_move}
  ```
  """
  def left({[], _right}), do: {:error, :invalid_move}

  def left({[new_focus | left], right}) do
    {:ok, {left, [new_focus | right]}}
  end

  @spec left?(t()) :: boolean()
  @doc """
  Return whether an element to the right exists.

  ```elixir
  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> {:ok, zipper} = Hold.Zipper.List.right(zipper)
  iex> Hold.Zipper.List.left?(zipper)
  true

  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> Hold.Zipper.List.left?(zipper)
  false
  ```
  """
  def left?({[], _right}), do: false
  def left?({[_next_left | _left], _right}), do: true

  @spec focus(t()) :: term()
  @doc """
  Return currently focused element.

  ```elixir
  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> Hold.Zipper.List.focus(zipper)
  1

  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> {:ok, zipper} = Hold.Zipper.List.right(zipper)
  iex> Hold.Zipper.List.focus(zipper)
  2
  ```
  """
  def focus({_left, [focus | _right]}), do: focus

  @spec update(t(), new_value :: term()) :: t()
  @doc """
  Updates the element which is currently focused.

  ```elixir
  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> {:ok, zipper} = Hold.Zipper.List.right(zipper)
  iex> zipper = Hold.Zipper.List.update(zipper, 20)
  iex> Hold.Zipper.List.to_list(zipper)
  [1, 20, 3, 4, 5]
  ```
  """
  def update({left, [_old_focus | right]}, new_value) do
    {left, [new_value | right]}
  end

  @spec first(t()) :: t()
  @doc """
  Return zipper with focus on the first element.

  ```elixir
  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> {:ok, zipper} = Hold.Zipper.List.right(zipper)
  iex> {:ok, zipper} = Hold.Zipper.List.right(zipper)
  iex> zipper = Hold.Zipper.List.first(zipper)
  iex> Hold.Zipper.List.focus(zipper)
  1
  ```
  """
  def first(zipper) do
    case left(zipper) do
      {:ok, new_zipper} ->
        first(new_zipper)

      {:error, :invalid_move} ->
        zipper
    end
  end

  @spec last(t()) :: t()
  @doc """
  Return zipper with focus on the last element.

  ```elixir
  iex> zipper = Hold.Zipper.List.from_list([1, 2, 3, 4, 5])
  iex> zipper = Hold.Zipper.List.last(zipper)
  iex> Hold.Zipper.List.focus(zipper)
  5
  ```
  """
  def last(zipper) do
    case right(zipper) do
      {:ok, new_zipper} ->
        last(new_zipper)

      {:error, :invalid_move} ->
        zipper
    end
  end
end
