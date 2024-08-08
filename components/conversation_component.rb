class ConversationComponent

  class << self
    def render
      <<~HTML
      <article>
        <div hx-ext="sse"
          sse-connect="/conversation"
          sse-swap="conversation"
          hx-swap="beforeend">
        </div>
      </article>
      HTML
    end

    def stream(out)
      ->(event, data) {
        message = data[:value]
        out << <<~OUT
          event: conversation
          data: <p class="#{event}">#{message}</p>
          \n\n
        OUT
      }
    end
  end
end
