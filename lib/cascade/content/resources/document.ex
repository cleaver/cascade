defmodule Cascade.Content.Document do
  @moduledoc """
  Ash resource for documents.
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "documents"
    repo Cascade.Repo
  end

  code_interface do
    define_for Cascade.Content
    define :create, args: [:author, :tags], action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
    define :get_by_id, args: [:id], action: :by_id
    define :publish, action: :publish
    define :index
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      argument :tags, {:array, :uuid}, allow_nil?: true
      change set_attribute(:inserted_at, DateTime.utc_now())
      change set_attribute(:updated_at, DateTime.utc_now())
      change manage_relationship(:tags, type: :append_and_remove)
    end

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end

    read :index do
      prepare build(sort: [updated_at: :desc])
    end

    update :publish do
      accept []
      change set_attribute(:publish_at, DateTime.utc_now())
    end

    update :update do
      primary? true

      argument :tags, {:array, :uuid} do
        allow_nil? true
      end

      change manage_relationship(:tags, type: :append_and_remove)
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
    end

    attribute :body, :string do
      allow_nil? false
    end

    attribute :slug, :string do
      allow_nil? false
    end

    attribute :publish_at, :utc_datetime do
      allow_nil? true
    end

    create_timestamp :inserted_at

    update_timestamp :updated_at
  end

  relationships do
    belongs_to :author, Cascade.Content.Author do
      attribute_writable? true
    end

    many_to_many :tags, Cascade.Content.Tag do
      through Cascade.Content.DocumentTag
      source_attribute_on_join_resource :document_id
      destination_attribute_on_join_resource :tag_id
    end
  end

  identities do
    identity :slug, [:slug] do
      eager_check_with Cascade.Content
    end
  end
end
