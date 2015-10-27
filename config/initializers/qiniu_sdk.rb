require 'qiniu'

Qiniu.establish_connection! :access_key => ENV['QINIU_ACCESSKEY'],
                            :secret_key => ENV['QINIU_SECRET']