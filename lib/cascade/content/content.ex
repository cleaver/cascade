defmodule Cascade.Content do
  use Ash.Api

  resources do
    registry Cascade.Content.Registry
    resource Cascade.Content.Author
    resource Cascade.Content.Document
    resource Cascade.Content.DocumentTag
    resource Cascade.Content.Tag
  end
end
