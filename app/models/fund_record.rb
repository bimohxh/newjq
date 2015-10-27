class FundRecord < ActiveRecord::Base
  belongs_to :mem
  def created_at
    super.strftime('%Y-%m-%d %H:%M:%S')  if super
  end

  #会员发布资源后获取的积分奖励
  def self.author_get item,num
    item.mem.get_money(num,'发布资源：' + item.title) 
  end

  #签到
  def self.checkin_get mem
    mem.get_money(1,'签到')
  end

  #会员发布插件内容通过后获取的积分奖励
  def self.plugincon_get item,num
    return if num < 1
    item.mem.get_money(num,'填加插件内容：' + item.plugin.title)
  end

  #下载插件包
  def self.plugin_give item,mem 
    return if item.cost < 1  
    mem.give_money(item.cost,'下载插件：' + item.title) 

    #作者加积分
    _get_num = (item.cost * 1.0 / 2).round
    if _get_num > 0 
     item.mem.get_money(_get_num,'你发表的插件：' + item.title + ' 被下载了')     
    end

    mem.buylogs << Buylog.create({:typ=>'plugin',:idcd=> item.id})
    
  end

  #播放视频
  def self.video_give item,num,mem 
    return if num < 1 
    mem.give_money(num,'播放视频：' + item.title)

    if num / 2 > 0 
      item.mem.get_money(num / 2,'你发表的视频：' + item.title + ' 被播放了')       
    end 
    mem.buylogs << Buylog.create({:typ=>'video',:idcd=> item.id}) 
  
  end

  #问问题
  def self.answer_give ask
    return if ask.money < 1
    ask.mem.give_money(ask.money,'你问了一个问题：' + ask.title)
  end

  #追加悬赏
  def self.ask_reward_give ask,num
    return if num < 1
    ask.mem.give_money(num,'你追加了悬赏：' + ask.title)
  end

  #采纳答案
  def self.answer_get ask
    return if ask.money < 1
    ask.mem.get_money(ask.money,'你的回答被采纳：' + ask.title)
  end

 #充值
  def self.recharge mem,num  
    return if num < 1
    mem.get_money(num,'在线充值')
  end

  #充值
  def self.card_recharge mem,num  
    return if num < 1
    mem.get_money(num,'充值卡充值')

    #card.used = '1'
    #current_mem.cards << card
    #card.save  
  end

  #积分操作
  def self.operate mem,num,remark
    mem.get_money(num,remark)
  end
end
