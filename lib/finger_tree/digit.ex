defmodule Hold.FingerTree.Digit do
  alias Hold.FingerTree
  alias Hold.FingerTree.Digit.{One, Two, Three, Four}

  @type t :: One.t() | Two.t() | Three.t() | Four.t()
  @type t(a) :: One.t(a) | Two.t(a) | Three.t(a) | Four.t(a)

  @callback to_tree(t()) :: FingerTree.t()

  @doc """
  Pop the left item of a digit off and downsize to smaller digit

  Error return is for `One` digit which can't downsize.
  """
  @callback head_l(t()) :: {term(), t()} | :error

  @doc """
  Pop the right item of a digit off and downsize to smaller digit

  Error return is for `One` digit which can't downsize.
  """
  @callback head_r(t()) :: {term(), t()} | :error
end
