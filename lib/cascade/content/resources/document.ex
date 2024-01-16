defmodule Cascade.Content.Document do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "documents"
    repo Cascade.Repo
  end

  code_interface do
    define_for Cascade.Content
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
    define :get_by_id, args: [:id], action: :by_id
    define :publish, action: :publish
    define :index
  end

  actions do
    defaults [:create, :read, :update, :destroy]

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
    belongs_to :author, Cascade.Content.Author

    many_to_many :tag, Cascade.Content.Tag do
      through Cascade.Content.DocumentTag
    end
  end

  identities do
    identity :slug, [:slug] do
      eager_check_with Cascade.Content
    end
  end
end
