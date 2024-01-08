defmodule CascadeWeb.DocumentLive.Index do
  use CascadeWeb, :live_view

  alias Cascade.Content
  alias Cascade.Content.Document

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :documents, Content.list_documents())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Document")
    |> assign(:document, Content.get_document!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Document")
    |> assign(:document, %Document{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Documents")
    |> assign(:document, nil)
  end

  @impl true
  def handle_info({CascadeWeb.DocumentLive.FormComponent, {:saved, document}}, socket) do
    {:noreply, stream_insert(socket, :documents, document)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    document = Content.get_document!(id)
    {:ok, _} = Content.delete_document(document)

    {:noreply, stream_delete(socket, :documents, document)}
  end
end
