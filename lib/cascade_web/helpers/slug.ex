defmodule CascadeWeb.Helpers.Slug do
  @moduledoc """
  This module generates slugs for documents.
  """

  @ignore_words ~w(an and as at be by for in is it its of on the to)

  @doc """
  Generate a slug from a string.

  ## Examples

      iex> alias CascadeWeb.Helpers.Slug
      iex> Slug.generate("Hello World")
      "hello-world"
      iex> Slug.generate("I have an apple!")
      "have-apple"

  """
  def generate(nil), do: ""

  def generate(source) do
    source
    |> String.downcase()
    |> String.split(~r/\W+/)
    |> Enum.reject(fn word -> String.length(word) < 2 or word in @ignore_words end)
    |> Enum.join("-")
  end
end
