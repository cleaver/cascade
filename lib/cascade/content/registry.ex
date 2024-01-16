defmodule Cascade.Content.Registry do
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
