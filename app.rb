require 'roda'
require 'zeitwerk'
loader = Zeitwerk::Loader.new
loader.push_dir('components')
loader.push_dir('layouts')
loader.push_dir('agents')
loader.push_dir('data')
loader.push_dir('events')
loader.setup

class App < Roda
  plugin :common_logger, $stdout
  plugin :streaming

  def self.logger
    self.opts[:common_logger]
  end

  route do |r|
    r.root do
      HtmlLayout.render do
        HeaderLayout.render do
          UserInputComponent.render
          MainLayout.render do
            AgentComponent.render(1) +
            ConversationComponent.render +
            AgentComponent.render(2)
          end
        end
      end
    end

    r.post 'user-input' do
      UserInputEvent.create(r.params['message'])
      UserInputComponent.render
    end

    r.get 'conversation' do
      response['Content-Type'] = 'text/event-stream'
      stream do |out|
        EventData.stream_latest(&
          ConversationComponent.stream(out))
      end
    end

    r.get 'agent', Integer do |id|
      response['Content-Type'] = 'text/event-stream'
      stream do |out|
        EventData.stream_latest(&
          RoleplayAgent.by(id).respond >>
          AgentComponent.by(id).stream(out))
      end
    end
  end

end
