defmodule Hold.FingerTree.Digit.One do
  @behaviour Hold.FingerTree.Digit
  alias Hold.FingerTree

  @type t :: %__MODULE__{
          a: term()
        }

  @type t(a) :: %__MODULE__{
          a: a
        }

  defstruct [:a]

  @spec new(term) :: t(term)
  @doc """
  Create a One
  """
  def new(a), do: %__MODULE__{a: a}

  @impl Hold.FingerTree.Digit
  @doc """
  Convert One into a `FingerTree.t()`
  """
  def to_tree(%__MODULE__{a: a}) do
    %FingerTree.Single{x: a}
  end

  @impl Hold.FingerTree.Digit
  def head_l(%__MODULE__{}), do: :error

  @impl Hold.FingerTree.Digit
  def head_r(%__MODULE__{}), do: :error
end
