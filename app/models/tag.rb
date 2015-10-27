class Tag < ActiveRecord::Base
  def self.hosts nums
    self.order('num desc').limit(nums).offset(0)
  end
end
