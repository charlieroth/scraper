defmodule ScrapingPipeline do
  use Broadway
  require Logger

  def start_link(_args) do
    opts = [
      name: ScrapingPipeline,
      producer: [
        module: {PageProducer, []},
        # transformer accepts a MFA tuple which will convert incoming events to
        # %Message structs
        transformer: {ScrapingPipeline, :transform, []}
      ],
      processors: [
        default: [max_demand: 1, concurrency: 2]
      ],
      batchers: [
        default: [batch_size: 1, concurrency: 2]
      ]
    ]

    Broadway.start_link(__MODULE__, opts)
  end

  def transform(event, _opts) do
    %Broadway.Message{
      data: event,
      # The acknowledger receives groups of messages that have been
      # processed, successfully or not. This is usually an opportunity
      # to contact the message broker and inform it of the outcome. We
      # don't really care in this case so there is a mock ack/3 function
      # below
      acknowledger: {ScrapingPipeline, :pages, []}
    }
  end

  # Receives the acknowledger id and two lists of successful and failed
  # messages. Perhaps in the future, if PageProducer has an internal
  # queue, you can send messages back to be retried
  def ack(:pages, _successful, _failed), do: :ok

  def handle_message(_processor, message, _context) do
    if Scraper.online?(message.data) do
      Broadway.Message.put_batch_key(message, message.data)
    else
      Broadway.Message.failed(message, "offline")
    end
  end

  def handle_batch(_batcher, [message], _batch_info, _context) do
    Logger.info("Batch processor received #{message.data}")
    Scraper.work()
    [message]
  end
end
