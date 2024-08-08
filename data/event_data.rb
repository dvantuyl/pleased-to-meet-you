class EventData
  class << self

    def stream_latest(&block)
      last_timestamp = Time.now.to_i
      while true
        greater_than(last_timestamp).each do |row|
          block.call(row[:event], JSON.parse(row[:data], symbolize_names: true))
          last_timestamp = row[:timestamp]
        end
        sleep 0.25
      end
    end

    def greater_than(last_timestamp)
      db[:events]
        .where { timestamp > last_timestamp }
    end

    def add(event, data)
      App.logger << "Adding event: #{event} with data: #{data}\n"
      timestamp = Time.now.to_i
      db[:events].insert(event: event, data: data.to_json, timestamp: timestamp)
    end

    private

    def db
      Sequel.connect('extralite://db/development.db')
    end

  end
end
