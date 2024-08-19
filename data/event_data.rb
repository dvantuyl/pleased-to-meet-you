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

    def insert(event)
      db.busy_timeout = 5
      db.execute(
        'insert into events (type, entity, message, timestamp) values (?, ?, ?, ?)',
        event.type, event.entity, event.message, event.timestamp)
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
