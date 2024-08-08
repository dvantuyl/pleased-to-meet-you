class AgentComponent

  class << self
    def render(id)
      <<~HTML
      <article>
        <header>
          <hgroup>
          <h3>Agent #{id}</h3>
          <p>Opinion</p>
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
      ->(message) {

        out << <<~OUT
          event: agent_#{to}
          data: <p>#{message}</p>
          \n\n
        OUT
      }
    end
  end
end
