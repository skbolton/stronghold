defmodule Hold.PairingHeapTest do
  use ExUnit.Case, async: true
  alias Hold.PairingHeap

  describe "pulling items from heap" do
    test "smallest item is returned" do
      heap =
        PairingHeap.new()
        |> PairingHeap.put(100, :c)
        |> PairingHeap.put(1, :a)
        |> PairingHeap.put(55, :b)

      assert {{1, :a}, heap} = PairingHeap.pop(heap)
      assert {{55, :b}, heap} = PairingHeap.pop(heap)
      assert {{100, :c}, _heap} = PairingHeap.pop(heap)
    end

    test "empty heap" do
      assert :error = PairingHeap.new() |> PairingHeap.pop()
    end
  end

  describe "peeking at top item in heap" do
    test "heap isn't modified" do
      heap = PairingHeap.new(1, :a)

      assert {1, :a} = PairingHeap.peek(heap)
      assert {1, :a} = PairingHeap.peek(heap)
    end
  end
end
