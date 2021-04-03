defmodule PageProducer do
  @moduledoc"""
  GenStage producer to handle demand from
  PageConsumer
  """
  use GenStage
  require Logger

  def init(state) do
    Logger.info("PageProducer init")
    {:producer, state}
  end

  def handle_demand(demand, state) do
    Logger.info("PageProducer received demand for #{demand} pages")
    events = []
    {:noreply, events, state}
  end

  def handle_cast({:pages, pages}, state) do
    {:noreply, pages, state}
  end
end
