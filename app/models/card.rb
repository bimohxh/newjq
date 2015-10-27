class Card < ActiveRecord::Base
  belongs_to :mem
  def created_at
    super.strftime('%Y-%m-%d %H:%M:%S')  if super
  end
end
