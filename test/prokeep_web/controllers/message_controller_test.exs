defmodule ProkeepWeb.MessageControllerTest do
  use ProkeepWeb.ConnCase
  use ExUnit.Case

  @moduletag capture_log: false
  test "returns 200 status code after proccessing messages asynchrony" do
    messages = [
      {"queue 1", "message 1"},
      {"queue 2", "message 2"},
      {"queue 3", "message 3"},
    ]

    responses_time =
      Enum.map(messages, fn {queue, message} ->
        :timer.tc(fn -> get(build_conn(), "/receive-message?message=#{message}&queue=#{queue}") end)
      end)

    # All responses are received in half a second or less
    assert Enum.all?(responses_time, fn {microseconds, _} -> microseconds <= 500_000 end)
  end
end
