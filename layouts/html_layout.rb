class HtmlLayout
  class << self

    def render(&slots)
      <<~HTML
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Multi Stream Ai</title>
          <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css"
          >
          <script src="https://unpkg.com/htmx.org@2.0.1" integrity="sha384-QWGpdj554B4ETpJJC9z+ZHJcA/i59TyjxEPXiiUgN2WmTyV5OEZWCD6gQhgkdpB/" crossorigin="anonymous"></script>
          <script src="https://unpkg.com/htmx-ext-sse@2.2.1/sse.js"></script>
        </head>
        <body>
          #{slots.call}
        </body>
      </html>
      HTML
    end
  end
end
