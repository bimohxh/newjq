class Mem::CodeController < MemController
  before_filter :is_me?
end
