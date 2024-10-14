defmodule Hold.FingerTree.Digit.Two do
  @behaviour Hold.FingerTree.Digit
  alias Hold.FingerTree

  @type t :: %__MODULE__{
          a: term(),
          b: term()
        }

  @type t(a) :: %__MODULE__{
          a: a,
          b: a
        }

  defstruct [:a, :b]

  @spec new(term, term) :: t(term)
  @doc """
  Create a new Two
  """
  def new(a, b), do: %__MODULE__{a: a, b: b}

  @impl Hold.FingerTree.Digit
  @doc """
  Convert Two into a `FingerTree.t()`
  """
  def to_tree(%__MODULE__{a: a, b: b}) do
    FingerTree.Deep.new(
      FingerTree.Digit.One.new(a),
      %FingerTree.Empty{},
      FingerTree.Digit.One.new(b)
    )
  end

  @impl Hold.FingerTree.Digit
  def head_l(%__MODULE__{a: a, b: b}) do
    {a, FingerTree.Digit.One.new(b)}
  end

  @impl Hold.FingerTree.Digit
  def head_r(%__MODULE__{a: a, b: b}), do: {b, FingerTree.Digit.One.new(a)}
end
