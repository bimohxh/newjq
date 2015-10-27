class Thief < ActiveRecord::Base
  def created_at
    super.strftime('%Y-%m-%d %H:%M:%S')  if super
  end
end
