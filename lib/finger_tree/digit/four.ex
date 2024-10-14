defmodule Hold.FingerTree.Digit.Four do
  @behaviour Hold.FingerTree.Digit
  alias Hold.FingerTree

  @type t :: %__MODULE__{
          a: term(),
          b: term(),
          c: term(),
          d: term()
        }

  @type t(a) :: %__MODULE__{
          a: a,
          b: a,
          c: a,
          d: a
        }

  defstruct [:a, :b, :c, :d]

  @spec new(term, term, term, term) :: t(term)
  @doc """
  Create a new Four
  """
  def new(a, b, c, d), do: %__MODULE__{a: a, b: b, c: c, d: d}

  @impl Hold.FingerTree.Digit
  @doc """
  Convert Four into a `FingerTree.t()`
  """
  def to_tree(%__MODULE__{a: a, b: b, c: c, d: d}) do
    FingerTree.Deep.new(
      FingerTree.Digit.Two.new(a, b),
      %FingerTree.Empty{},
      FingerTree.Digit.Two.new(c, d)
    )
  end

  @impl Hold.FingerTree.Digit
  def head_l(%__MODULE__{a: a, b: b, c: c, d: d}) do
    {a, FingerTree.Digit.Three.new(b, c, d)}
  end

  @impl Hold.FingerTree.Digit
  def head_r(%__MODULE__{a: a, b: b, c: c, d: d}), do: {d, FingerTree.Digit.Three.new(a, b, c)}
end
