defmodule CascadeWeb.AuthorLive.Show do
  use CascadeWeb, :live_view

  alias Cascade.Content.Author

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:author, Author.get_by_id!(id))}
  end

  defp page_title(:show), do: "Show Author"
  defp page_title(:edit), do: "Edit Author"
end
