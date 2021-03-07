defmodule Scraper do
  def scrape_pages(pages) when is_list(pages) do
    GenStage.cast(PageProducer, {:pages, pages})
  end

  def online?(_url) do
    # Pretend we are checking if the service is
    # oneline or not
    work()
    # Select result randomly
    Enum.random([false, true, true])
  end

  def work() do
    # Pretend to do web scraping
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end
end
