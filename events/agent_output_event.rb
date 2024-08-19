class AgentOutputEvent
  class << self
    def record(entity, message)
      EventData::Record.new(name, entity, message, Time.now.to_i)
    end
  end
end
