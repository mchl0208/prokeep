defmodule ProkeepWeb.MessageController do
  use ProkeepWeb, :controller
  alias Prokeep.MessageQueue

  def receive_message(conn, %{"queue" => queue, "message" => message}) do
    MessageQueue.start_link(queue)
    # Genserver.cast({MessageQueue, queue}, {:add_message, message})

    # Return a 200 status code
    send_resp(conn, :ok, "")
  end
end
