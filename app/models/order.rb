class Order < ActiveRecord::Base
	belongs_to :mem
	
  def created_at
    super.strftime('%Y-%m-%d %H:%M:%S') if super
  end

  def state_alia
    Refcd.key('PAYMENT',state).first.sdesc
  end


end
