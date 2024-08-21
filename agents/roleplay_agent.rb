class RoleplayAgent
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def respond_to(event)
      return nil if event.entity == 'user' && event.entity == 'agent-2' ||
                    event.entity == "agent-#{id}"

      agent = RoleplayAgent.new(id)
      agent.respond_to_memory(event)
  end


  def respond_to_memory(event)

    message = llm.generate({
      model: 'llama3.1',
      system: system,
      prompt: prompt(event),
      stream: false
    }).then(& parse_response)

    EventData.insert(AgentOutputEvent.record("agent-#{id}", message))
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

  def system
    <<~SYSTEM
      You are roleplaying as agent-#{id}. You are responsible for responding to the memories of agent-#{id == 1 ? 2 : 1}.

      Each memory is a relationship with between you and other entities in chronological order from past to present:

      #{memories}

    SYSTEM
  end

  def prompt(event)
    event.message
  end

  def memories
    MemoryData.for_agent_id(id).map { |row| "- #{row[:memory]}" }.join("\n")
  end

end
