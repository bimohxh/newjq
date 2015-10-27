class Mem::VideoController < MemController
  before_filter :is_me?
end
