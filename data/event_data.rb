require 'extralite'

class EventData

  Record = Data.define(:type, :entity, :message, :timestamp)
  class << self

    def stream_latest(&block)
      last_timestamp = Time.now.to_i
      while true
        greater_than(last_timestamp).each do |row|
          block.call(Record.new(row[:type], row[:entity], row[:message], row[:timestamp]))
          last_timestamp = row[:timestamp]
        end
        sleep 0.25
      end
    end

    def insert(event, retries: 3)
      db.busy_timeout = 5
      db.execute(
        'INSERT INTO events (type, entity, message, timestamp) VALUES (?, ?, ?, ?)',
        event.type, event.entity, event.message, event.timestamp)
    rescue SQLite3::BusyException
      insert(event, retries: retries - 1) if retries > 0
    end

    private

    def greater_than(last_timestamp)
      db.query('SELECT * FROM events WHERE timestamp > ?', last_timestamp)
    end

    def db
      Extralite::Database.new('db/development.db', wal: true)
    end
  end
end
