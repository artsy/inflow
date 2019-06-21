# Inflow

An experimental batch imports application written in Elixir/Phoenix

[![CircleCI](https://circleci.com/gh/artsy/inflow.svg?style=svg)](https://circleci.com/gh/artsy/inflow)

## Why are we doing this?

* A chance to try a real-world Phoenix application for learning
* The current batch import application, [Currents](https://github.com/artsy/currents/) began using an experimental architecture (Gris/Braque) and was subsequently changed into a "regular" Rails application, but still has a lot of odd corners due to that earlier implementation.
* Currents does a lot of its work using Sidekiq, and Elixir/Phoenix allows us to parallelize more work without the additional need for a delayed-job setup.
* The parallelism and [Live View](https://github.com/phoenixframework/phoenix_live_view) from Phoenix allow us to provide more rapid feedback as errors occur, rather than waiting on Sidekiq jobs to update database tables and then reloading pages to see the results. An example is the request to know during an import how many artworks have been created and images added in real time.

## Getting started

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Install Node.js dependencies with `cd assets && npm install`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

* Official website: http://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
