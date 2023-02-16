defmodule ProkeepWeb.PageController do
  use ProkeepWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
