class UserInputComponent
  class << self

    def render
      <<~HTML
      <form hx-post="/user-input" hx-target="this">
        <fieldset role="group">
          <input type="text" name="message" placeholder="Pleased to meet you..">
          <button>Speak</button>
        </fieldset>
      </form>
      HTML
    end
  end
end
