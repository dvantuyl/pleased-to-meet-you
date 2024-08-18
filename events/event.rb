class Event


  def self.from(event, data)
    case event
    in UserInputEvent::TYPE
      UserInputEvent.new(data[:message])
    else
      raise "Unknown event '#{event}'"
    end
  end
end
