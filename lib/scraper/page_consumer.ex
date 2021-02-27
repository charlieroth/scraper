defmodule Scraper.PageConsumer do
  use GenStage
  require Logger

  def start_link(args) do
    initial_state = []

    args =
      if Keyword.has_key?(args, :id) do
        args
      else
        Keyword.put(args, :id, random_job_id())
      end

    id = Keyword.get(args, :id)
    GenStage.start_link(__MODULE__, initial_state, name: via(id))
  end

  def init(state) do
    Logger.info("PageConsumer init")
    sub_opts = [{Scraper.PageProducer, min_demand: 0, max_demand: 1}]
    {:consumer, state, subscribe_to: sub_opts}
  end

  def handle_events(events, _from, state) do
    Logger.info("PageConsumer received #{inspect(events)}")

    # Pretending that we're scraping web pages
    Enum.each(events, fn _page ->
      Scraper.work()
    end)

    {:noreply, [], state}
  end

  defp via(key) do
    {:via, Registry, {Scraper.Registry, key}}
  end

  defp random_job_id() do
    :crypto.strong_rand_bytes(5) |> Base.url_encode64(padding: false)
  end
end
