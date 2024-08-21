require 'extralite'

class MemoryData

  Record = Data.define(:agent_id, :entity, :memory, :timestamp)
  class << self

    def for_agent_id(agent_id)
      db(agent_id).query('SELECT * FROM memories ORDER BY timestamp ASC')
    end

    def insert(agent_id, entity, memory, retries: 3)
      db(agent_id).busy_timeout = 5
      db(agent_id).execute(
        'INSERT INTO memories (entity, memory, timestamp) VALUES (?, ?, ?)',
        entity, memory, Time.now.to_i)
    rescue SQLite3::BusyException
      insert(agent_id, entity, memory, retries: retries - 1) if retries > 0
    end

    private


    def db(id)
      Extralite::Database.new("db/agent-#{id}.db", wal: true)
    end
  end
end
