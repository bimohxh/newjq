#encoding: utf-8
require 'rubygems'
require 'rufus-scheduler'  

scheduler = Rufus::Scheduler.new

#定时清空缓存
#scheduler.cron '01 03 * * *'  do 
#  #Rails.logger.info "hello, it's #{Time.now}"
#  require 'fileutils'
#  FileUtils.rm_r  "#{Rails.root}/public/cache", :force => true 
#end

#测试定时器
#scheduler.cron '40 23 * * *'  do
#	Rails.logger.error "hello, it's #{Time.now}" 
#  #ActiveRecord::Base.connection.execute("DELETE from buylogs") 
#end
#定时清空购买记录
scheduler.cron '1 0 * * *'  do
  ActiveRecord::Base.connection.execute("DELETE from buylogs")
end