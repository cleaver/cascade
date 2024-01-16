defmodule CascadeWeb.DocumentLive.FormComponent do
  use CascadeWeb, :live_component

  alias Cascade.Content.Document
  alias CascadeWeb.Helpers.Slug

  @api Cascade.Content

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage document records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="document-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <.input field={@form[:body]} type="textarea" label="Body" />
        <.input field={@form[:publish_at]} type="datetime-local" label="Publish at" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Document</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{action: action, document: document} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_form(action, document)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => document_params}, socket) do
    IO.inspect(document_params, label: "document_params")
    form = AshPhoenix.Form.validate(socket.assigns.form, document_params) |> to_form()
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"form" => document_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: document_params) do
      {:ok, document} ->
        notify_parent({:saved, document})

        socket =
          socket
          |> put_flash(:info, "Saved document #{document.title}!")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp assign_form(socket, :edit, document) do
    assign(socket, :form, AshPhoenix.Form.for_update(document, :update, api: @api) |> to_form())
  end

  defp assign_form(socket, :new, _document) do
    assign(socket, :form, AshPhoenix.Form.for_create(Document, :create, api: @api) |> to_form())
  end
end
