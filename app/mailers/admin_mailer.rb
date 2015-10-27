class AdminMailer < ActionMailer::Base
  default from: "1246996371@qq.com"
  
  def feedback item
    @item = item
    mail(to: ['1246996371@qq.com'],subject: "有用户提交了网站反馈")
  end  

  def mem item
    @item = item 
    mail(to: @item[:receiver],subject:  @item[:title])
  end

  def rullerapp item
    @item = item
    mail(to: ['67971087@qq.com'],subject: "你的IOS直尺APP有反馈了")
  end

  def findpwd item
    @item = item 
    mail(to: @item[:receiver],subject:  "jQuery插件库找回密码")
  end

end
