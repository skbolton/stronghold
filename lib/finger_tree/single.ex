defmodule Hold.FingerTree.Single do
  @moduledoc """
  Reord for signifying a Finger Tree with one element.
  """

  @type t :: %__MODULE__{
          x: any()
        }

  @type t(value) :: %__MODULE__{
          x: value
        }

  defstruct [:x]
end
