defmodule Scraper do
  def work() do
    # Pretend to do web scraping
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end
end
