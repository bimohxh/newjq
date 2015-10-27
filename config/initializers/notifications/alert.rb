ActiveSupport::Notifications.subscribe "comment.create" do |*args|
  data = args.extract_options!
  _item = data[:item]
  AlertJob.new({:mem_id=>_item.target.mem_id,:title=>'你收到了新的评论！',:link=> "/comment/#{_item.target.id}"}).enqueue 
end

ActiveSupport::Notifications.subscribe "follow.create" do |*args|
  data = args.extract_options!
  _mem = data[:tomem]
  AlertJob.new({:mem_id=>_mem.id,:title=>"会员：#{data[:nc]} 关注了你！",:link=> "/mem/followers"}).enqueue 
end

ActiveSupport::Notifications.subscribe "source.destroy" do |*args|
  data = args.extract_options!
  _item = data[:item]
  AlertJob.new({:mem_id=>_item.mem.id,:title=> "你发布的资源：#{_item.title} 被管理员删除了，原因：#{data[:reason]}！",:link=> nil}).enqueue 
end

ActiveSupport::Notifications.subscribe "source.check" do |*args|
  data = args.extract_options!
  _item = data[:item]
  AlertJob.new({:mem_id=>_item.mem.id,:title=> "你发布的资源：#{_item.title} 通过审核了！",:link=> data[:url]}).enqueue 
end


ActiveSupport::Notifications.subscribe "mem.unread" do |*args|
  data = args.extract_options!
  AlertRemoveJob.new(data[:ids]).enqueue 
end

