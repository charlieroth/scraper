defmodule PageConsumer do
  @moduledoc"""
  Consumer process to perform work delegated
  by the PageConsumerSupervisor
  """
  require Logger

  def start_link(event) do
    Logger.info("PageConsumer received #{event}")
    # Pretending that we're scraping web pages
    Task.start_link(fn ->
      Scraper.work()
    end)
  end
end
