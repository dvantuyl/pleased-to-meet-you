class AgentComponent

  def initialize(id)
    @id = id
  end

  def stream(out)
    AgentComponent.stream(out, to: @id)
  end

  class << self

    def by(id)
      self.new(id)
    end

    def render(id)
      <<~HTML
      <article>
        <header>
          <hgroup>
          <h3>Agent #{id}</h3>
          <p>Memory</p>
          </hgroup
        </header>
        <div hx-ext="sse"
          sse-connect="/agent/#{id}"
          sse-swap="agent_#{id}"
          hx-swap="beforeend">
        </div>
      </article>
      HTML
    end

    def stream(out, to:)
      ->(event) {
        if event&.message
          out << <<~OUT
            event: agent_#{to}
            data: <p>#{event.message}</p>
            \n\n
          OUT
        end
      }
    end
  end
end
