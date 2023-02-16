defmodule Prokeep.MessageQueue do
  @moduledoc """
  A rate limiter for processing messages.
  """

  use GenServer
  require Logger

  def start_link(queue_name) do
    GenServer.start_link(__MODULE__, queue_name, name: name_for(queue_name))
  end

  def name_for(queue_name) do
    {:global, {:message_queue, queue_name}}
  end

  def init(queue_name) do
    schedule_message_proccessing();
    {:ok, %{name: queue_name, messages: []}}
  end

  defp schedule_message_proccessing() do
    interval = Application.get_env(:prokeep, :message_processing_interval, 1000)
    Process.send_after(self(), :process_messages, interval)
  end

  def handle_cast({:add_message, message}, state) do
    new_state = %{state | messages: [message | state.messages]}
    {:noreply, new_state}
  end

  def handle_info(:process_messages, state) do
    {message, new_state} = pop_message(state)
    if not is_nil(message) do
      Logger.info("Processed message '#{message}' from queue '#{state.name}'")
    end

    interval = Application.get_env(:prokeep, :message_processing_interval, 1000)
    Process.send_after(self(), :process_messages, interval)
    {:noreply, new_state}
  end

  defp pop_message(%{messages: []} = state) do
    {nil, state}
  end

  defp pop_message(%{messages: [message | rest]} = state) do
    {message, %{state | messages: rest}}
  end
end
