defmodule ProkeepWeb.MessageController do
  use ProkeepWeb, :controller
  use GenServer
  alias Prokeep.MessageQueue

  def receive_message(conn, %{"queue" => queue, "message" => message}) do
    {:ok, pid} = MessageQueue.start_link(queue)
    GenServer.cast(pid, {:add_message, message})

    # Return a 200 status code
    send_resp(conn, :ok, "")
  end
end
