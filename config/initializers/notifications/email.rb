ActiveSupport::Notifications.subscribe "comment.create" do |*args|
  data = args.extract_options!
  _url = "#{Rails.application.config.base_url}#{data[:typ]}/#{data[:idcd]}"
  #Rails.logger.error "=========你发布的资源有了新的评论!=====#{_url}====="
  

  _email = data[:item].target.mem.email
  if _email and _email.include? '@'
    _item = {:receiver=> _email,:title=>'你有新的评论',:con=>"你在jQuery插件库发布的资源有了新的评论，点击链接查看：#{_url}"}
    MailerJob.new(_item).enqueue 
  end
end


