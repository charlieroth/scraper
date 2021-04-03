defmodule Scraper do
  @moduledoc"""
  API to interact with Scraper application
  """
  def scrape_pages(pages) when is_list(pages) do
    # Since Broadway controls startup, we need to find
    # the available producers to send messages to
    ScrapingPipeline
    |> Broadway.producer_names()
    |> List.first()
    |> GenStage.cast({:pages, pages})
  end

  def online?(_url) do
    # Pretend we are checking if the service is
    # oneline or not
    work()
    Enum.random([false, true, true])
  end

  def work() do
    Enum.random(1..5)
    |> :timer.seconds()
    |> Process.sleep()
  end
end
