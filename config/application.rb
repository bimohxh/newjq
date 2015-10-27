require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Newjq
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = 'zh-CN'
    
    config.active_record.default_timezone = :local
    config.time_zone = 'Beijing'

    config.encrypt_key="42#3b-c$dxyT,7a5=+5fUI3fa7352&^:"
    
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address              =>  ENV['SMTP_ADDRESS'],
      :port                 => 25,
      :user_name            => ENV['SMTP_USER_NAME'],
      :password             =>  ENV['SMTP_PWD'],
      :authentication       => 'plain',
      :enable_starttls_auto => true
    }

    config.source_upload_path = "/upload/"
    config.source_access_path = ENV['SOURCE_ACCESS_PATH']

    #七牛
    config.qiniu_upload = ENV['QINIU_UPLOAD']
    config.qiniu_base = ENV['QINIU_BASE']

    #demo地址
    config.demo_base = ENV['DEMO_BASE']

    #本地资源
    config.assets_base = ENV['ASSETS_BASE']

    #阿里云
    config.aliyun_access_path = ENV['ALIYUN_ACCESS_PATH']
    config.aliyun_access_id = ENV['ALIYUN_ACCESS_ID']
    config.aliyun_access_key = ENV['ALIYUN_ACCESS_KEY']
    config.aliyun_bucket = ENV['ALIYUN_BUCKET']
    config.aliyun_area = ENV['ALIYUN_AREA']
    config.aliyun_upload_host = ENV['ALIYUN_UPLOAD_HOST']
    
    
    

    #发布资源积分回报
    config.plugin_back = 5
    config.code_back = 2
    config.video_back = 30

    #充值积分
    config.payback = [{:rmb =>'10',:val =>'50'},{:rmb =>'30',:val =>'170'},{:rmb =>'50',:val =>'300'}]
    #config.payback = [{:rmb =>'10',:val =>'100'},{:rmb =>'30',:val =>'320'},{:rmb =>'50',:val =>'560'}]
   
    config.admin_uid = ENV['ADMIN_UID']
    config.admin_pwd = ENV['ADMIN_PWD']
    #补丁
    class ActiveSupport::TimeWithZone 
        def friendly
            _time = Time.at(Time.new - self)
            _attrs = [:year,:month,:day,:hour,:min,:sec]
            _base_time = Time.at(0)
            _diff = _attrs.map{|_attr|
              _time.send(_attr) - _base_time.send(_attr)
            }.each_with_index{|tim,index|
              return [tim.to_s,_attrs[index].to_s] if tim > 0
            }
            [0, 'sec']
        end 

        def friendly_i18n
            _diff = friendly 
            if _diff[1] == 'sec' 
              I18n.t('justnow')
            else
              _diff[0] + I18n.t(_diff[1]) + I18n.t('ago')
            end
        end
    end
    
  end
end
