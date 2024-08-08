class HeaderLayout
  class << self

    def render(&slots)
      <<~HTML
        <header class="container">
          #{UserInputComponent.render}
        </header>
        #{slots.call}
      HTML
    end
  end
end
