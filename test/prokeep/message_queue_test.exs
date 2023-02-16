defmodule Prokeep.MessageQueueTest do
  use ProkeepWeb.ConnCase
  import ExUnit.CaptureLog

  alias Prokeep.MessageQueue

  @moduletag capture_log: true
  test "processes messages once per second" do
    {:ok, pid} = MessageQueue.start_link("test_queue")

    messages = ["message 1", "message 2", "message 3", "message 4", "message 5"]

    # insert a bunch of messages
    messages
    |> Enum.each(& GenServer.cast(pid, {:add_message, &1}))

    {:noreply, %{messages: messages}} = MessageQueue.handle_info(:process_messages, %{messages: ["some data"], name: "test_queue"})

    # No messages has been processed
    assert length(messages) == 0

    assert capture_log(fn ->
      # Use the GenServer's handle_info function to trigger the log message
      MessageQueue.handle_info(:process_messages, %{messages: messages, name: "test_queue"})

      # Wait for the log message to be written
      :timer.sleep(1000)
    end) =~ "Processed message 'message 5' from queue 'test_queue'"

    # Try sending another message immediately after the first one.
    assert capture_log(fn ->
      MessageQueue.handle_info(:process_messages, %{messages: messages, name: "test_queue"})
    end) =~ ""

    # Event now no messages has been processed
    assert capture_log(fn ->
      MessageQueue.handle_info(:process_messages, %{messages: messages, name: "test_queue"})
    end) =~ ""

    # Wait for a second, and try sending another message. This should be processed.
    assert capture_log(fn ->
      MessageQueue.handle_info(:process_messages, %{messages: messages, name: "test_queue"})
      :timer.sleep(1000)
    end) =~ "Processed message 'message 4' from queue 'test_queue'"

    # No more messages has been processed in less than 1 second
    assert capture_log(fn ->
      MessageQueue.handle_info(:process_messages, %{messages: messages, name: "test_queue"})

      :timer.sleep(500)
    end) =~ ""

    # After one more second the next message should be processed.
    assert capture_log(fn ->
      MessageQueue.handle_info(:process_messages, %{messages: messages, name: "test_queue"})

      :timer.sleep(1000)
    end) =~ "Processed message 'message 3' from queue 'test_queue'"
  end
end
