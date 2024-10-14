defmodule Hold.FingerTree.Node do
  alias Hold.FingerTree.Digit

  defmodule Node2 do
    @type t :: %__MODULE__{
            a: term(),
            b: term()
          }

    # TODO: according to paper types of props can be different?
    @type t(a) :: %__MODULE__{
            a: a,
            b: a
          }

    defstruct [:a, :b]

    @spec new(term, term) :: t(term)
    @doc """
    Create a new Node3
    """
    def new(a, b) do
      %__MODULE__{
        a: a,
        b: b
      }
    end

    @spec to_digit(t()) :: Digit.Two.t()
    @doc """
    Convert Node2 into a Digit.Two
    """
    def to_digit(%__MODULE__{a: a, b: b}) do
      Digit.Two.new(a, b)
    end
  end

  defmodule Node3 do
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
    Create a new Node3
    """
    def new(a, b, c) do
      %__MODULE__{
        a: a,
        b: b,
        c: c
      }
    end

    @spec to_digit(t()) :: Digit.Three.t()
    @doc """
    Convert Node3 into a Digit.Three
    """
    def to_digit(%__MODULE__{a: a, b: b, c: c}) do
      Digit.Three.new(a, b, c)
    end
  end

  @type t :: Node2.t() | Node3.t()
  @type t(a) :: Node2.t(a) | Node3.t(a)
end
