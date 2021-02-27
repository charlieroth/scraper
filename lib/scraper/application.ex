defmodule Scraper.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Scraper.Registry},
      Scraper.PageProducer,
      Supervisor.child_spec(Scraper.PageConsumer, id: :consumer_a),
      Supervisor.child_spec(Scraper.PageConsumer, id: :consumer_b)
    ]

    opts = [strategy: :one_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
