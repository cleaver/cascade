defmodule Cascade.Content.Registry do
  @moduledoc """
  Registry for content resources.
  """
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry Cascade.Content.Author
    entry Cascade.Content.Document
    entry Cascade.Content.DocumentTag
    entry Cascade.Content.Tag
  end
end
