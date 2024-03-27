defmodule Cascade.Repo.Migrations.CreateDocuments do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:documents, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :title, :text, null: false
      add :body, :text, null: false
      add :slug, :text, null: false
      add :publish_at, :utc_datetime
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")

      add :author_id,
          references(:authors,
            column: :id,
            name: "documents_author_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end

    create unique_index(:documents, [:slug], name: "documents_slug_index")

    create table(:document_tags, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true

      add :document_id,
          references(:documents,
            column: :id,
            name: "document_tags_document_id_fkey",
            type: :uuid,
            prefix: "public"
          )

      add :tag_id,
          references(:tags,
            column: :id,
            name: "document_tags_tag_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end
  end

  def down do
    drop constraint(:document_tags, "document_tags_document_id_fkey")

    drop constraint(:document_tags, "document_tags_tag_id_fkey")

    drop table(:document_tags)

    drop_if_exists unique_index(:documents, [:slug], name: "documents_slug_index")

    drop constraint(:documents, "documents_author_id_fkey")

    drop table(:documents)
  end
end
