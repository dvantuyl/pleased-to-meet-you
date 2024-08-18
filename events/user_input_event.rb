  class UserInputEvent < Event
    attr_reader :message

    TYPE = 'user_input'

    def initialize(message)
      @message = message
    end

    def serialize
      { message: @message }.to_json
    end

    def type
      TYPE
    end


    class << self

      def create(message, insert_action = EventData.insert)
        insert_action.call(new(message))
      end
    end

  end
