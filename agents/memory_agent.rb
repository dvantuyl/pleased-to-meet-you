class MemoryAgent
  attr_reader :id

  def self.by(id)
    MemoryAgent.new(id)
  end

  def initialize(id)
    @id = id
  end

  def store
    ->(event) {
      memory = case event.type
      when AgentOutputEvent.name
        create_memory(event)
      when UserInputEvent.name
        create_memory(event)
      end

      if memory
        MemoryData.insert(id, event.entity, memory)
        RoleplayAgent.new(id).respond_to(event)

        AgentMemoryEvent.record("agent-#{id}", memory)
      end
    }
  end

  private

  def create_memory(event)
    llm.generate({
      model: 'llama3.1',
      system: system,
      prompt: prompt(event),
      stream: false
    }).then(& parse_response)
  end

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
      You are the memories of entity "agent-#{id}".

      Each memory is a relationship with between you and other entities in chronological order from past to present:

      #{memories}

    SYSTEM
  end

  def prompt(event)
    <<~PROMPT
      Entity "#{event.entity}" provided the following message:
      ```
      #{event.message}
      ```

      Incorporate this message into your memory as a new item in order to continue building the relationships between
      you and other entities.
      Make sure to note the context of the message and how it relates to the other memories.
      Build off of previous memories as much as possible.
      You must incorporate the message from the entity "#{event.entity}.
    PROMPT
  end

  def memories
    MemoryData.for_agent_id(id).map { |row| "- #{row[:memory]}" }.join("\n")
  end
end
