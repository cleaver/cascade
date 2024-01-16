defmodule CascadeWeb.TagLive.Index do
  use CascadeWeb, :live_view

  alias Cascade.Content.Tag

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tags, Tag.index!())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tag")
    |> assign(:tag, Tag.get_by_id!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tag")
    |> assign(:tag, %Tag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tags")
    |> assign(:tag, nil)
  end

  @impl true
  def handle_info({CascadeWeb.TagLive.FormComponent, {:saved, tag}}, socket) do
    {:noreply, stream_insert(socket, :tags, tag)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tag = Tag.get_by_id!(id)
    Tag.destroy!(tag)

    {:noreply, stream_delete(socket, :tags, tag)}
  end
end
