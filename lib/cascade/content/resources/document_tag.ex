defmodule Cascade.Content.DocumentTag do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "document_tags"
    repo Cascade.Repo
  end

  attributes do
    uuid_primary_key :id
  end

  relationships do
    belongs_to :document, Cascade.Content.Document
    belongs_to :tag, Cascade.Content.Tag
  end
end
