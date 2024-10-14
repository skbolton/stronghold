defmodule Hold.FingerTree.Digit.Three do
  @behaviour Hold.FingerTree.Digit
  alias Hold.FingerTree

  @type t :: %__MODULE__{
          a: term(),
          b: term(),
          c: term()
        }

  @type t(a) :: %__MODULE__{
          a: a,
          b: a,
          c: a
        }

  defstruct [:a, :b, :c]

  @spec new(term, term, term) :: t(term)
  @doc """
  Create a new Three
  """
  def new(a, b, c), do: %__MODULE__{a: a, b: b, c: c}

  @impl Hold.FingerTree.Digit
  @doc """
  Convert Three into a `FingerTree.t()`
  """
  def to_tree(%__MODULE__{a: a, b: b, c: c}) do
    FingerTree.Deep.new(
      FingerTree.Digit.Two.new(a, b),
      %FingerTree.Empty{},
      FingerTree.Digit.One.new(c)
    )
  end

  @impl Hold.FingerTree.Digit
  def head_l(%__MODULE__{a: a, b: b, c: c}) do
    {a, FingerTree.Digit.Two.new(b, c)}
  end

  @impl Hold.FingerTree.Digit
  def head_r(%__MODULE__{a: a, b: b, c: c}), do: {c, FingerTree.Digit.Two.new(a, b)}
end
