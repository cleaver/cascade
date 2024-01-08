defmodule Cascade.Content.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(title body slug author_id)a
  @optional_fields ~w(publish_at)a
  @all_fields @required_fields ++ @optional_fields

  schema "documents" do
    field :title, :string
    field :body, :string
    field :slug, :string
    field :publish_at, :utc_datetime
    field :author_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
