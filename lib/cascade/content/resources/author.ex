defmodule Cascade.Content.Author do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "authors"
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
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      get? true
      filter expr(id == ^arg(:id))
    end

    read :index do
      prepare build(sort: [name: :asc])
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
end
