require 'sneakers'
require 'sneakers/metrics/logging_metrics'
require 'sneakers/handlers/maxretry'
require 'json'

opts = {
  amqp: ENV['AMPQ_ADDRESS'] || 'amqp://localhost:5672',
  vhost: '/',
  exchange: 'sneakers',
  exchange_type: :direct,
  metrics: Sneakers::Metrics::LoggingMetrics.new,
  handler: Sneakers::Handlers::Maxretry
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::INFO

class GradeSource
  include Sneakers::Worker
  from_queue :grade_source

  def work(params)
    params = JSON.parse(params)
    Sneakers::Publisher.new.publish(result(params), to_queue: :store_result)
    ack!
  end

  def result(params)
    {
      source_code_id: params['source_code_id'],
      points: Random.rand(100)
    }.to_json
  end
end
