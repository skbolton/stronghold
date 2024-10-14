defmodule Hold.FingerTree.Empty do
  @moduledoc """
  Record for signifying an empty finger tree.
  """

  @type t :: %__MODULE__{}

  defstruct []
end
