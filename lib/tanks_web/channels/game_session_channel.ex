defmodule TanksWeb.GameSessionChannel do
  use TanksWeb, :channel

  def join("game_session:" <> name, %{"userName" => user_name}, socket) do
    if authorized?(payload) do
      socket =
        socket
        |> assign(:name, name)
        |> assign(:user, user_name)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("effect", %{}, socket) do
    {:reply, :ack, socket}
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
