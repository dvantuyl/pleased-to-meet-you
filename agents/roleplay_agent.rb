class RoleplayAgent

  def initialize(id)
    @id = id
  end

  def respond
    RoleplayAgent.respond(@id)
  end

  class << self

    def by(id)
      RoleplayAgent.new(id)
    end

    def respond(id)
      ->(event) {
        case event.type
        in UserInputEvent::TYPE
          handle_user_input(event)
        else
          App.logger << "Wrong event '#{event.type}'"
        end
      }
    end

    private

    def llm
      Ollama.new(
        credentials: { address: 'http://localhost:11434' },
        options: {
          connection: { adapter: :net_http },
          server_sent_events: false
        }
      )
    end

    def parse_response
      ->(response) {
        response.first["response"]
      }
    end

    def handle_user_input(event)
      #history = MemoryData.for_agent_id(id).map { |row| row[:memory] }
      llm.generate({
        model: 'llama3.1',
        prompt: event.message,
        stream: false
      }).then(& parse_response)
    end
  end

end
