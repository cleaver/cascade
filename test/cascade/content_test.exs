defmodule Cascade.ContentTest do
  use Cascade.DataCase

  alias Cascade.Content

  describe "authors" do
    alias Cascade.Content.Author

    import Cascade.ContentFixtures

    @invalid_attrs %{name: nil}

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Content.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Content.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Author{} = author} = Content.create_author(valid_attrs)
      assert author.name == "some name"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Author{} = author} = Content.update_author(author, update_attrs)
      assert author.name == "some updated name"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_author(author, @invalid_attrs)
      assert author == Content.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Content.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Content.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Content.change_author(author)
    end
  end

  describe "tags" do
    alias Cascade.Content.Tag

    import Cascade.ContentFixtures

    @invalid_attrs %{name: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Content.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Content.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Tag{} = tag} = Content.create_tag(valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Tag{} = tag} = Content.update_tag(tag, update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_tag(tag, @invalid_attrs)
      assert tag == Content.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Content.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Content.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Content.change_tag(tag)
    end
  end

  describe "documents" do
    alias Cascade.Content.Document

    import Cascade.ContentFixtures

    @invalid_attrs %{title: nil, body: nil, slug: nil, publish_at: nil}

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert Content.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Content.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      valid_attrs = %{title: "some title", body: "some body", slug: "some slug", publish_at: ~U[2024-01-07 19:49:00Z]}

      assert {:ok, %Document{} = document} = Content.create_document(valid_attrs)
      assert document.title == "some title"
      assert document.body == "some body"
      assert document.slug == "some slug"
      assert document.publish_at == ~U[2024-01-07 19:49:00Z]
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body", slug: "some updated slug", publish_at: ~U[2024-01-08 19:49:00Z]}

      assert {:ok, %Document{} = document} = Content.update_document(document, update_attrs)
      assert document.title == "some updated title"
      assert document.body == "some updated body"
      assert document.slug == "some updated slug"
      assert document.publish_at == ~U[2024-01-08 19:49:00Z]
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_document(document, @invalid_attrs)
      assert document == Content.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Content.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Content.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Content.change_document(document)
    end
  end
end
