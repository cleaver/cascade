defmodule Cascade.ContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cascade.Context` context.
  """

  @doc """
  Generate a gift.
  """
  def gift_fixture(attrs \\ %{}) do
    {:ok, gift} =
      attrs
      |> Enum.into(%{
        body: "some body",
        publish_at: ~U[2024-01-07 19:39:00Z],
        slug: "some slug",
        title: "some title"
      })
      |> Cascade.Context.create_gift()

    gift
  end
end
