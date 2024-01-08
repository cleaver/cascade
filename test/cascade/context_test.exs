defmodule Cascade.ContextTest do
  use Cascade.DataCase

  alias Cascade.Context

  describe "gifts" do
    alias Cascade.Context.Gift

    import Cascade.ContextFixtures

    @invalid_attrs %{title: nil, body: nil, slug: nil, publish_at: nil}

    test "list_gifts/0 returns all gifts" do
      gift = gift_fixture()
      assert Context.list_gifts() == [gift]
    end

    test "get_gift!/1 returns the gift with given id" do
      gift = gift_fixture()
      assert Context.get_gift!(gift.id) == gift
    end

    test "create_gift/1 with valid data creates a gift" do
      valid_attrs = %{title: "some title", body: "some body", slug: "some slug", publish_at: ~U[2024-01-07 19:39:00Z]}

      assert {:ok, %Gift{} = gift} = Context.create_gift(valid_attrs)
      assert gift.title == "some title"
      assert gift.body == "some body"
      assert gift.slug == "some slug"
      assert gift.publish_at == ~U[2024-01-07 19:39:00Z]
    end

    test "create_gift/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Context.create_gift(@invalid_attrs)
    end

    test "update_gift/2 with valid data updates the gift" do
      gift = gift_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body", slug: "some updated slug", publish_at: ~U[2024-01-08 19:39:00Z]}

      assert {:ok, %Gift{} = gift} = Context.update_gift(gift, update_attrs)
      assert gift.title == "some updated title"
      assert gift.body == "some updated body"
      assert gift.slug == "some updated slug"
      assert gift.publish_at == ~U[2024-01-08 19:39:00Z]
    end

    test "update_gift/2 with invalid data returns error changeset" do
      gift = gift_fixture()
      assert {:error, %Ecto.Changeset{}} = Context.update_gift(gift, @invalid_attrs)
      assert gift == Context.get_gift!(gift.id)
    end

    test "delete_gift/1 deletes the gift" do
      gift = gift_fixture()
      assert {:ok, %Gift{}} = Context.delete_gift(gift)
      assert_raise Ecto.NoResultsError, fn -> Context.get_gift!(gift.id) end
    end

    test "change_gift/1 returns a gift changeset" do
      gift = gift_fixture()
      assert %Ecto.Changeset{} = Context.change_gift(gift)
    end
  end
end
