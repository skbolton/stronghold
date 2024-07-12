defmodule Hold.Zipper do
  @typedoc """
  Error when an invalid move would have been performed.

  One requirement of a zipper is that you always must be able be able to
  maintain a focus on an element. Any moves that would result in the focus
  looking at nothing will result in this error. Example: Moving right when no
  right sibling exists
  """
  @type invalid_move :: {:error, :invalid_move}
end
