defmodule Scraper do
  def scrape_pages(pages) when is_list(pages) do
    GenStage.cast(PageProducer, {:pages, pages})
  end

  def work() do
    # Pretend to do web scraping
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end
end
