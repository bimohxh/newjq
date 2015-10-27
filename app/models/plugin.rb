class Plugin < ActiveRecord::Base
  has_many :plugincons, dependent: :destroy
	belongs_to :mem 

  def download_url
  	if download[0..6] != 'http://'  
  		 Rails.application.config.assets_base + 'plugin/' + download
    else
      download
    end
  end

  def demo_url
    if demo[0..6] != 'http://'  
      Rails.application.config.demo_base + demo
    else
      demo
    end
    
  end
  
  def self.list_field
    self.select('id,title,pic,mem_id,`desc`')
  end 

  def created_at
    super.strftime('%Y-%m-%d')  if super
  end

  def updated_at
    super.strftime('%Y-%m-%d')  if super
  end

  def prev
    Plugin.select('id,title').where("recsts = '0' and id > #{id}").order('id asc').limit(1).offset(0)[0]
  end

  def next
    Plugin.select('id,title').where("recsts = '0' and id < #{id}").order('id desc').limit(1).offset(0)[0]
  end
  
end
