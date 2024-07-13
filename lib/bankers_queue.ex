defmodule Hold.BankersQueue do
  @moduledoc """
  A double ended queue (deque) implementation.

  Double ended queues optimize for adding items to one end of the queue and
  removing from the other - FIFO queues.
  """

  @type sized_list :: {length :: non_neg_integer(), []}
  @type sized_list(a) :: {length :: non_neg_integer(), [a]}

  @type t(a) :: {rear :: sized_list(a), front :: sized_list(a)}
  @type t :: {rear :: sized_list(), front :: sized_list()}

  @spec new() :: t()
  @doc """
  Create a new queue.
  """
  def new() do
    {_rear = {0, []}, _front = {0, []}}
  end

  @spec from_list(list()) :: t()
  @doc """
  Create a new queue from a list keepin the same order of the original list;
  the head item of the list is the first item in the queue.

  ```elixir
  iex> queue = Hold.BankersQueue.from_list([1, 2, 3, 4, 5])
  iex> Hold.BankersQueue.peek(queue)
  {:value, 1}
  ```
  """
  def from_list(list) when is_list(list) do
    {{0, []}, {length(list), list}}
  end

  @spec enqueue(t(), term()) :: t()
  @doc """
  Add `item` to `queue`.

  ```elixir
  iex> queue = Hold.BankersQueue.new()
  iex> queue = Hold.BankersQueue.enqueue(queue, 1)
  iex> Hold.BankersQueue.peek(queue)
  {:value, 1}
  ```
  """
  def enqueue({{rear_count, rear}, front}, item) do
    check_balance({{rear_count + 1, [item | rear]}, front})
  end

  @spec dequeue(t()) :: {:value, {term, t()}} | {:empty, t()}
  @doc """
  Removes first item in `queue`.

  Returns `{:value, {item, queu}}` where `item` is what was removed and `queue`
  is the remaining queue. In cases where the queue is empty `{:empty, queue}`
  is retruned.

  ```elixir
  iex> queue = Hold.BankersQueue.new()
  iex> queue = Hold.BankersQueue.enqueue(queue, 1)
  iex> {:value, {1, queue}} = Hold.BankersQueue.dequeue(queue)
  iex> Hold.BankersQueue.peek(queue)
  :empty
  ```
  """
  def dequeue({_rear, {0, []}} = queue) do
    {:empty, queue}
  end

  def dequeue({rear, {front_count, [item | rest]}}) do
    {:value, {item, check_balance({rear, {front_count - 1, rest}})}}
  end

  def peek({_rear, {_front_count, [item | _rest]}}), do: {:value, item}
  def peek(_empty_queue), do: :empty

  defp check_balance({{rear_count, _rear}, {front_count, _front}} = balanced)
       when front_count > rear_count,
       do: balanced

  defp check_balance({{rear_count, rear}, {front_count, front}}) do
    {{0, []}, {rear_count + front_count, Enum.concat(front, Enum.reverse(rear))}}
  end
end
