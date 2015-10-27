class Plugincon < ActiveRecord::Base
	belongs_to :mem
	belongs_to :plugin

	def created_at
    super.strftime('%Y-%m-%d')  if super
  end
end
