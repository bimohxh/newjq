Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :tqq, ENV['TQQ_KEY'], ENV['TQQ_SECRET']
  provider :weibo, ENV['WEIBO_KEY'], ENV['WEIBO_SECRET']
  provider :qq_connect, ENV['QQ_KEY'], ENV['QQ_SECRET']
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
end