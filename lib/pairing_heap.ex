defmodule Hold.PairingHeap do
  @moduledoc """
  See: https://en.wikipedia.org/wiki/Pairing_heap
  """

  @type rank :: integer()
  @type item :: any()

  @type element :: {rank(), item()}
  @type element(a) :: {rank(), a}

  @type t :: %__MODULE__{
          node: element() | :empty,
          children: [t()]
        }

  @type t(a) :: %__MODULE__{
          node: element(a) | :empty,
          children: [t(a)]
        }

  defstruct [:node, :children]

  @spec new() :: t()
  @doc """
  Create a new empty PairingHeap
  """
  def new(), do: %__MODULE__{node: :empty, children: []}

  @spec new(rank, item) :: t()
  @doc """
  Create a new PairingHeap with initial element
  """
  def new(rank, item), do: %__MODULE__{node: {rank, item}, children: []}

  @spec empty?(t()) :: boolean()
  @doc """
  Return whether heap has elements
  """
  def empty?(%__MODULE__{node: :empty}), do: true
  def empty?(%__MODULE__{node: _non_empty}), do: false

  @spec peek(t()) :: element() | :empty
  @doc """
  Return top priority item in the heap without changing heap.

  To remove the item from the heap and return a new heap see `pop/1`.
  """
  def peek(%__MODULE__{node: node}), do: node

  @spec put(t(), integer(), any()) :: t()
  @doc """
  Place new `item` with `rank` into heap.
  """
  def put(%__MODULE__{node: :empty}, rank, item) do
    %__MODULE__{
      node: {rank, item},
      children: []
    }
  end

  @spec put(t(), integer(), any()) :: t()
  def put(%__MODULE__{} = heap, rank, item) do
    merge(heap, new(rank, item))
  end

  @spec merge(t(), t()) :: t()
  @doc """
  Merge two or more heaps together.
  """
  def merge(
        %__MODULE__{node: {rank1, _value2}, children: children} = heap1,
        %__MODULE__{node: {rank2, _value}} = heap2
      )
      when rank1 <= rank2 do
    %__MODULE__{
      heap1
      | children: [heap2 | children]
    }
  end

  def merge(heap1, heap2) do
    %__MODULE__{
      node: heap2.node,
      children: [heap1 | heap2.children]
    }
  end

  def merge([heap]), do: heap
  def merge([heap1, heap2]), do: merge(heap1, heap2)

  def merge([heap1, heap2 | rest]) do
    merge(
      merge(heap1, heap2),
      merge(rest)
    )
  end

  @spec pop(t()) :: {element(), t()} | :error
  @doc """
  Remove top item from the heap.
  """
  def pop(%__MODULE__{node: :empty}), do: :error

  def pop(%__MODULE__{node: node, children: children} = heap) do
    updated_heap =
      case children do
        [] ->
          %{heap | node: :empty}

        has_children ->
          merge(has_children)
      end

    {node, updated_heap}
  end
end
