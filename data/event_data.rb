class EventData
  class << self

    def stream_latest(&block)
      last_timestamp = Time.now.to_i
      while true
        greater_than(last_timestamp).each do |row|
          block.call(Event.from(row[:event], JSON.parse(row[:data], symbolize_names: true)))
          last_timestamp = row[:timestamp]
        end
        sleep 0.25
      end
    end


    def insert
      ->(event) {
        timestamp = Time.now.to_i
        db[:events].insert(event: event.type, data: event.serialize, timestamp: timestamp)
      }
    end

    private

    def greater_than(last_timestamp)
      db[:events]
        .where { timestamp > last_timestamp }
    end

    def db
      Sequel.connect('extralite://db/development.db')
    end

  end
end
