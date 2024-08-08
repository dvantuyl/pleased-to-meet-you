class MainLayout
  class << self

    def render(&slots)
      <<~HTML
        <main class="container-fluid">
          #{slots.call}
        </main>
        <style>
          main {
            display: grid;
            grid-template-columns:
              repeat(auto-fit, minmax(min(300px, 100%), 1fr));
            gap: 1rem;
          }
          main > * {
            padding: 1rem;
          }
        </style>
      HTML
    end
  end
end
