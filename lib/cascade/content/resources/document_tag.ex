defmodule Cascade.Content.DocumentTag do
  @moduledoc """
  Ash resource to associate documents with tags.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "document_tags"
    repo Cascade.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  relationships do
    belongs_to :document, Cascade.Content.Document,
      primary_key?: true,
      allow_nil?: false

    belongs_to :tag, Cascade.Content.Tag,
      primary_key?: true,
      allow_nil?: false
  end
end
