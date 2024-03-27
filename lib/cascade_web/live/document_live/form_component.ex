defmodule CascadeWeb.DocumentLive.FormComponent do
  @moduledoc """
  The form component for the document live view.
  """
  alias Phoenix.HTML.Tag
  use CascadeWeb, :live_component

  alias Cascade.Content.Author
  alias Cascade.Content.Document
  alias Cascade.Content.Tag
  alias CascadeWeb.Helpers.Slug

  @api Cascade.Content

  @impl true
  def update(%{action: action, document: document} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_form(action, document)
      |> assign_options()

    {:ok, socket}
  end

  @impl true
  def handle_event("generate-slug", _, socket) do
    title = AshPhoenix.Form.value(socket.assigns.form, :title)

    params =
      socket.assigns.form
      |> AshPhoenix.Form.params()
      |> Map.put("slug", Slug.generate(title))

    form = socket.assigns.form |> AshPhoenix.Form.validate(params) |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("delete_tag", %{"tag_id" => tag_id}, socket) do
    tag = Tag.get_by_id!(tag_id)
    selected_tags = remove_tag(socket.assigns.selected_tags, tag)
    tag_options = add_tag(socket.assigns.tag_options, tag)
    socket = assign(socket, selected_tags: selected_tags, tag_options: tag_options)

    {:noreply, socket}
  end

  def handle_event(
        "validate",
        %{"_target" => ["form", "add_tag_id"], "form" => %{"add_tag_id" => add_tag_id}},
        socket
      ) do
    added_tag = Tag.get_by_id!(add_tag_id)
    selected_tags = add_tag(socket.assigns.selected_tags, added_tag)
    tag_options = remove_tag(socket.assigns.tag_options, added_tag)
    socket = assign(socket, selected_tags: selected_tags, tag_options: tag_options)

    {:noreply, socket}
  end

  def handle_event("validate", %{"form" => document_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, document_params) |> to_form()
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"form" => document_params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, document_params, errors: true)

    document_params =
      Map.put(document_params, "tags", Enum.map(socket.assigns.selected_tags, & &1.id))

    if length(form.source.source.errors) > 0 do
      {:noreply, assign(socket, form: form)}
    else
      save_document(socket, form.source, document_params)
    end
  end

  defp save_document(socket, %{action: :create} = _changeset, document_params) do
    case Ash.Changeset.for_create(Document, :create, document_params) |> @api.create() do
      {:ok, document} ->
        redirect_on_success(socket, document)

      {:error, changeset} ->
        {:noreply, assign(socket, form: changeset |> to_form())}
    end
  end

  defp save_document(socket, %{action: :update} = _changeset, document_params) do
    case Ash.Changeset.for_update(socket.assigns.document, :update, document_params)
         |> @api.update() do
      {:ok, document} ->
        redirect_on_success(socket, document)

      {:error, changeset} ->
        {:noreply, assign(socket, form: changeset |> to_form())}
    end
  end

  defp redirect_on_success(socket, document) do
    notify_parent({:saved, document})

    socket =
      socket
      |> put_flash(:info, "Saved document #{document.title}!")
      |> push_patch(to: socket.assigns.patch)

    {:noreply, socket}
  end

  defp add_tag(list, tag) do
    (list ++ [tag])
    |> Enum.sort(&(&1.name < &2.name))
  end

  defp remove_tag(list, tag_to_remove) do
    Enum.reject(list, fn tag -> tag.id == tag_to_remove.id end)
  end

  defp assign_options(socket) do
    socket
    |> assign_authors()
    |> assign_selected_tags()
    |> assign_available_tags()
  end

  defp assign_authors(socket) do
    authors =
      Author.list_options!()
      |> Enum.map(fn author -> {author.name, author.id} end)

    assign(socket, :authors, authors)
  end

  defp assign_selected_tags(%{assigns: %{selected_tags: _}} = socket), do: socket

  defp assign_selected_tags(%{assigns: assigns} = socket) do
    selected_tags =
      case assigns.document.tags do
        [_ | _] = tags ->
          tags

        _ ->
          []
      end

    assign(socket, selected_tags: selected_tags)
  end

  defp assign_available_tags(%{assigns: %{selected_tags: selected_tags}} = socket) do
    selected_tag_ids = Enum.map(selected_tags, & &1.id)

    tags =
      Tag.list_options!()
      |> Enum.reject(fn tag -> tag.id in selected_tag_ids end)

    assign(socket, :tag_options, tags)
  end

  defp prepare_options(tag_list) do
    tag_list
    |> Enum.map(fn tag -> {tag.name, tag.id} end)
  end

  defp tag_label(assigns) do
    ~H"""
    <button
      type="button"
      phx-click="delete_tag"
      phx-value-tag_id={@id}
      phx-target={@target}
      class="pl-4 pr-2 py-2 bg-slate-300 rounded m-2"
    >
      <%= @name %>
      <.icon name="hero-x-mark-solid" class="h-4 w-4 ml-4 mb-0.5" />
    </button>
    """
  end

  defp assign_form(socket, :edit, document) do
    document = Cascade.Content.load!(document, [:author, :tags])

    assign(
      socket,
      document: document,
      form: AshPhoenix.Form.for_update(document, :update, api: @api) |> to_form()
    )
  end

  defp assign_form(socket, :new, _document) do
    assign(
      socket,
      :form,
      AshPhoenix.Form.for_create(Document, :create, api: @api) |> to_form()
    )
  end
end
