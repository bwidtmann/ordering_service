# encoding: utf-8
require "bunny"

CLIENT_NAME = ARGV.empty? ? 'server' : ARGV.join(" ")

class Receiver

  def initialize
    conn = Bunny.new
    conn.start
    ch = conn.create_channel

    @queue = ch.queue(CLIENT_NAME)
  end

  def receive
    puts " [*] Waiting for messages in #{@queue.name}. To exit press CTRL+C"
    @queue.subscribe(:block => false) do |delivery_info, properties, body|
      puts " [x] Received #{body.inspect} from #{properties.app_id}"

      # send it to proper receiver (customer_client or guest_client)
      Sender.new(properties.reply_to, CLIENT_NAME).send(body, properties.app_id)

      # cancel the consumer to exit
      #delivery_info.consumer.cancel
    end
  end

end