defmodule Scraper.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Producer/ProducerConsumer must be started before Consumer
    # children = [
    #   {Registry, keys: :unique, name: ProducerConsumerRegistry},
    #   PageProducer,
    #   producer_consumer_spec(id: 1),
    #   producer_consumer_spec(id: 2),
    #   PageConsumerSupervisor
    # ]
    children = [
      ScrapingPipeline
    ]
    opts = [strategy: :one_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def producer_consumer_spec(id: id) do
    id = "online_page_producer_consumer_#{id}"
    Supervisor.child_spec({OnlinePageProducerConsumer, id}, id: id)
  end
end
