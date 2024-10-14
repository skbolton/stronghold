defmodule Hold.FingerTree do
  alias Hold.FingerTree.{Deep, Digit, Empty, Node, Single}

  @type t(a) ::
          Empty.t()
          | Single.t(a)
          | Deep.t(a)

  @type t ::
          Empty.t()
          | Single.t()
          | Deep.t()

  def new(), do: %Empty{}

  @spec cons(t(), term()) :: t()
  @doc """
  Add new item to the beginning of finger tree.

  Complexity - O(1)
  """
  def cons(%Empty{}, x) do
    %Single{x: x}
  end

  def cons(%Single{x: b}, a) do
    Deep.new(
      %Digit.One{a: a},
      %Empty{},
      %Digit.One{a: b}
    )
  end

  def cons(%Deep{pr: %Digit.One{a: b}} = deep, a) do
    %{deep | pr: %Digit.Two{a: a, b: b}}
  end

  def cons(%Deep{pr: %Digit.Two{a: b, b: c}} = deep, a) do
    %{deep | pr: %Digit.Three{a: a, b: b, c: c}}
  end

  def cons(%Deep{pr: %Digit.Three{a: b, b: c, c: d}} = deep, a) do
    %{deep | pr: %Digit.Four{a: a, b: b, c: c, d: d}}
  end

  def cons(%Deep{pr: %Digit.Four{a: b, b: c, c: d, d: e}} = deep, a) do
    %{
      deep
      | pr: %Digit.Two{a: a, b: b},
        m: cons(deep.m, Node.Node3.new(c, d, e))
    }
  end

  @spec snoc(t(), term()) :: t()
  @doc """
  Add item to the end of finger tree.

  Complexity: 0(1)
  """
  def snoc(%Empty{} = tree, a) do
    cons(tree, a)
  end

  def snoc(%Single{x: a}, b) do
    Deep.new(
      Digit.One.new(a),
      %Empty{},
      Digit.One.new(b)
    )
  end

  def snoc(%Deep{sf: %Digit.One{a: a}} = tree, b) do
    %{tree | sf: %Digit.Two{a: a, b: b}}
  end

  def snoc(%Deep{sf: %Digit.Two{a: a, b: b}} = tree, c) do
    %{tree | sf: %Digit.Three{a: a, b: b, c: c}}
  end

  def snoc(%Deep{sf: %Digit.Three{a: a, b: b, c: c}} = tree, d) do
    %{tree | sf: %Digit.Four{a: a, b: b, c: c, d: d}}
  end

  def snoc(%Deep{sf: %Digit.Four{a: a, b: b, c: c, d: d}} = tree, e) do
    %{
      tree
      | sf: %Digit.Two{a: d, b: e},
        m: snoc(tree.m, Node.Node3.new(a, b, c))
    }
  end

  @spec view_l(t()) :: nil | {term(), t(term())}
  @doc """
  Analyze the left end of finger tree
  """
  def view_l(%Empty{}), do: nil
  def view_l(%Single{x: x}), do: {x, %Empty{}}

  def view_l(%Deep{pr: %Digit.One{a: a}, m: m, sf: sf}) do
    case view_l(m) do
      nil ->
        # middle tree is empty convert suffix to a tree
        {a, sf.__struct__.to_tree(sf)}

      {b, new_middle} ->
        {a,
         Deep.new(
           # TODO: I didn't understand the node here
           # I think the middle of the finger tree is still confusing for me
           b.__struct__.to_digit(b),
           new_middle,
           sf
         )}
    end
  end

  def view_l(%Deep{pr: pr, m: m, sf: sf}) do
    {a, digit} = pr.__struct__.head_l(pr)

    {a,
     Deep.new(
       digit,
       m,
       sf
     )}
  end

  def view_r(%Empty{}), do: nil
  def view_r(%Single{x: x}), do: {%Empty{}, x}

  def view_r(%Deep{sf: %Digit.One{a: a}, m: m, pr: pr}) do
    case view_r(m) do
      nil ->
        # middle tree is empty convert prefix to a tree
        {pr.__struct__.to_tree(pr), a}

      {new_middle, b} ->
        {
          Deep.new(
            pr,
            new_middle,
            # TODO: I didn't understand the node here
            # I think the middle of the finger tree is still confusing for me
            b.__struct__.to_digit(b)
          ),
          a
        }
    end
  end

  def view_r(%Deep{pr: pr, m: m, sf: sf}) do
    {a, digit} = sf.__struct__.head_r(sf)

    {
      Deep.new(
        pr,
        m,
        digit
      ),
      a
    }
  end
end
