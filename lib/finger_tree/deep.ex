defmodule Hold.FingerTree.Deep do
  # alias Hold.Protocol.{Measured, Monoid}

  @type t :: %__MODULE__{
          pr: Hold.FingerTree.Digit.t(),
          m: Hold.FingerTree.t(),
          sf: Hold.FingerTree.Digit.t()
        }

  @type t(a) :: %__MODULE__{
          pr: Hold.FingerTree.Digit.t(a),
          m: Hold.FingerTree.t(a),
          sf: Hold.FingerTree.Digit.t(a)
        }

  defstruct [:pr, :m, :sf]

  def new(prefix, middle, suffix) do
    %__MODULE__{
      pr: prefix,
      m: middle,
      sf: suffix
    }
  end
end
