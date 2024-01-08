defmodule Cascade.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cascade.Content` context.
  """

  @doc """
  Generate a author.
  """
  def author_fixture(attrs \\ %{}) do
    {:ok, author} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Cascade.Content.create_author()

    author
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Cascade.Content.create_tag()

    tag
  end

  @doc """
  Generate a document.
  """
  def document_fixture(attrs \\ %{}) do
    {:ok, document} =
      attrs
      |> Enum.into(%{
        body: "some body",
        publish_at: ~U[2024-01-07 19:49:00Z],
        slug: "some slug",
        title: "some title"
      })
      |> Cascade.Content.create_document()

    document
  end
end
