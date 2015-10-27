class Alert < ActiveRecord::Base
  belongs_to :mem


  def self.send_fans tomem
    self.sent tomem,"你有新的粉丝！",''
  end

  def self.send_comment tomem,comid
    self.sent tomem,"你收到了新的评论！","/comment/#{comid}"
  end

  def self.send_reply tomem
    self.sent tomem,"你收到了新的回复！",''
  end

  def self.sent tomem,title,link
    self.create({:mem_id=>tomem,:title=>title,:link=> link})
  end

end
