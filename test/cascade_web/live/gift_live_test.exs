defmodule CascadeWeb.GiftLiveTest do
  use CascadeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cascade.ContextFixtures

  @create_attrs %{title: "some title", body: "some body", slug: "some slug", publish_at: "2024-01-07T19:39:00Z"}
  @update_attrs %{title: "some updated title", body: "some updated body", slug: "some updated slug", publish_at: "2024-01-08T19:39:00Z"}
  @invalid_attrs %{title: nil, body: nil, slug: nil, publish_at: nil}

  defp create_gift(_) do
    gift = gift_fixture()
    %{gift: gift}
  end

  describe "Index" do
    setup [:create_gift]

    test "lists all gifts", %{conn: conn, gift: gift} do
      {:ok, _index_live, html} = live(conn, ~p"/gifts")

      assert html =~ "Listing Gifts"
      assert html =~ gift.title
    end

    test "saves new gift", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/gifts")

      assert index_live |> element("a", "New Gift") |> render_click() =~
               "New Gift"

      assert_patch(index_live, ~p"/gifts/new")

      assert index_live
             |> form("#gift-form", gift: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#gift-form", gift: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/gifts")

      html = render(index_live)
      assert html =~ "Gift created successfully"
      assert html =~ "some title"
    end

    test "updates gift in listing", %{conn: conn, gift: gift} do
      {:ok, index_live, _html} = live(conn, ~p"/gifts")

      assert index_live |> element("#gifts-#{gift.id} a", "Edit") |> render_click() =~
               "Edit Gift"

      assert_patch(index_live, ~p"/gifts/#{gift}/edit")

      assert index_live
             |> form("#gift-form", gift: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#gift-form", gift: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/gifts")

      html = render(index_live)
      assert html =~ "Gift updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes gift in listing", %{conn: conn, gift: gift} do
      {:ok, index_live, _html} = live(conn, ~p"/gifts")

      assert index_live |> element("#gifts-#{gift.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#gifts-#{gift.id}")
    end
  end

  describe "Show" do
    setup [:create_gift]

    test "displays gift", %{conn: conn, gift: gift} do
      {:ok, _show_live, html} = live(conn, ~p"/gifts/#{gift}")

      assert html =~ "Show Gift"
      assert html =~ gift.title
    end

    test "updates gift within modal", %{conn: conn, gift: gift} do
      {:ok, show_live, _html} = live(conn, ~p"/gifts/#{gift}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Gift"

      assert_patch(show_live, ~p"/gifts/#{gift}/show/edit")

      assert show_live
             |> form("#gift-form", gift: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#gift-form", gift: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/gifts/#{gift}")

      html = render(show_live)
      assert html =~ "Gift updated successfully"
      assert html =~ "some updated title"
    end
  end
end
