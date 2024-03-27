defmodule CascadeWeb.TagLive.FormComponent do
  use CascadeWeb, :live_component

  alias Cascade.Content.Tag

  @api Cascade.Content

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tag records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tag-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tag</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{action: action, tag: tag} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_form(action, tag)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => tag_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, tag_params) |> to_form()
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"form" => tag_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: tag_params) do
      {:ok, tag} ->
        notify_parent({:saved, tag})

        socket =
          socket
          |> put_flash(:info, "Saved tag #{tag.name}!")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp assign_form(socket, :edit, tag) do
    assign(socket, :form, AshPhoenix.Form.for_update(tag, :update, api: @api) |> to_form())
  end

  defp assign_form(socket, :new, _tag) do
    assign(socket, :form, AshPhoenix.Form.for_create(Tag, :create, api: @api) |> to_form())
  end
end
