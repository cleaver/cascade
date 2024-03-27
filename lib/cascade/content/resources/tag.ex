defmodule Cascade.Content.Tag do
  @moduledoc """
  Ash resource for tags.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tags"
    repo Cascade.Repo
  end

  code_interface do
    define_for Cascade.Content
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
    define :get_by_id, args: [:id], action: :by_id
    define :index
    define :list_options
  end

  actions do
    defaults [:create, :read, :destroy]

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end

    read :index do
      prepare build(sort: [name: :asc])
    end

    read :list_options do
      prepare build(sort: [name: :asc])
    end

    update :update do
      primary? true

      argument :documents, {:array, :map} do
        allow_nil? true
      end

      change manage_relationship(:documents, type: :append_and_remove)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at

    update_timestamp :updated_at
  end

  relationships do
    many_to_many :documents, Cascade.Content.Document do
      through Cascade.Content.DocumentTag
      source_attribute_on_join_resource :tag_id
      destination_attribute_on_join_resource :document_id
    end
  end
end
