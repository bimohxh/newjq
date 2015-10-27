class Mem::PluginController < MemController
  before_filter :is_me?
end
