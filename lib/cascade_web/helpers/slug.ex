defmodule CascadeWeb.Helpers.Slug do
  @moduledoc """
  This module generates slugs for documents.
  """

  @ignore_words ~w(an and as at be by for in is it its of on the to)

  @doc """
  Generate a slug from a string.

  ## Examples

      iex> import CascadeWeb.Helpers.Slug
      iex> Slug.generate("Hello World")
      "hello-world"
      iex> Slug.generate("I have an apple!")
      "have-apple"

  """
  def generate(source) do
    source
    |> String.downcase()
    |> String.split(~r/\W+/)
    |> Enum.reject(&(String.length(&1) < 2))
    |> Enum.reject(&(&1 in @ignore_words))
    |> Enum.join("-")
  end
end
