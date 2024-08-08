class RoleplayAgent
  class << self

    def generate
      ->(event, data) {
        model = 'llama3.1'
        prompt = data[:value]
        case event
        when 'user_input'
          llm.generate({
            model:,
            prompt:,
            stream: false
          }).then(& parse_response)

        else
          App.logger << "Wrong event '#{event}'"
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
  end

end
