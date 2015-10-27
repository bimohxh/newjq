class Doc < ActiveRecord::Base
  def created_at
    super.strftime('%Y-%m-%d')  if super
  end
end
