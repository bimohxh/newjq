module MemHelper
  def who isme
    isme ? '我' : 'TA'
  end

  def checked_num
    Checkin.where(["begdt = ? or enddt = ? ",Date.today,Date.today]).count
  end

  def ischeckin?
    
  end

  
end
