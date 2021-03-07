defmodule OnlinePageProducerConsumer do
  use GenStage
  require Logger

  def start_link(id) do
    state = []
    name = {:via, Registry, {ProducerConsumerRegistry, id, []}}
    GenStage.start_link(__MODULE__, state, name: name)
  end

  def init(state) do
    Logger.info("OnlinePageProducerConsumer init")

    subscription = [
      {PageProducer, min_demand: 0, max_demand: 1}
    ]

    {:producer_consumer, state, subscribe_to: subscription}
  end

  def handle_events(events, _from, state) do
    Logger.info("OnlinePageProducerConsumer received #{inspect(events)}")
    events = Enum.filter(events, &Scraper.online?/1)
    {:noreply, events, state}
  end
end
