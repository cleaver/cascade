defmodule CascadeWeb.AuthorLive.FormComponent do
  use CascadeWeb, :live_component

  alias Cascade.Content.Author

  @api Cascade.Content

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage author records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="author-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Author</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{action: action, author: author} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_form(action, author)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => author_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, author_params) |> to_form()
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"form" => author_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: author_params) do
      {:ok, author} ->
        notify_parent({:saved, author})

        socket =
          socket
          |> put_flash(:info, "Saved author #{author.name}!")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp assign_form(socket, :edit, author) do
    assign(socket, :form, AshPhoenix.Form.for_update(author, :update, api: @api) |> to_form())
  end

  defp assign_form(socket, :new, _author) do
    assign(socket, :form, AshPhoenix.Form.for_create(Author, :create, api: @api) |> to_form())
  end
end
