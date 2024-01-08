defmodule Cascade.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :title, :string
      add :body, :text
      add :slug, :string
      add :publish_at, :utc_datetime
      add :author_id, references(:authors, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:documents, [:author_id])
  end
end
