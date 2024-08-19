class UserInputEvent

  class << self
    def record(message)
      EventData::Record.new(name, 'user', message, Time.now.to_i)
    end
  end
end
