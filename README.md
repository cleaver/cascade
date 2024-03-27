# Cascade

A basic headless CMS using Phoenix and Ash.

## Todo

- [ ] Clean up DocumentLive.FormComponent
  - [ ] Use Nested Forms
  - [ ] Remove the CRUD stuff.
- [ ] Add GraphQL

## Converting to Ash

This application was created as a conventional Phoenix LiveView application with Ecto. The Ecto 
context and schemas were replaced by Ash resources. [See the details](converting-to-ash.md).

## Starting Phoenix

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

