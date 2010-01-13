require 'appengine-rack'
AppEngine::Rack.configure_app(
  :application => 'ro-devil-dict',
  :version => 1
)

require 'dict_main'
run Sinatra::Application
