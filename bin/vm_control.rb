# frozen_string_literal: true

def change_status(payload)
  payload = JSON.parse(payload)
  puts 'Starting really slow task!'

  10.times do
    putc '.'
    # sleep 1
  end
  puts '.'

  puts "Payload: #{payload}"
  puts 'Slow task finished'
  client = HTTPClient.new
  response = client.request(:get, "http://app:3000/api/orders/change_status", { id: payload })
  puts result = JSON.parse(response.body)
end

require 'httpclient'
require 'eventmachine'
require 'bunny'
require 'json'
EventMachine.run do
  connection = Bunny.new('amqp://guest:guest@rabbitmq')
  connection.start

  channel = connection.create_channel
  queue = channel.queue('vm.control', auto_delete: true)

  queue.subscribe do |_delivery_info, _metadata, payload|
    change_status(payload)
  end

  Signal.trap('INT') do
    puts 'exiting INT'
    connection.close { EventMachine.stop }
  end

  Signal.trap('TERM') do
    puts 'killing TERM'
    connection.close { EventMachine.stop }
  end
end
