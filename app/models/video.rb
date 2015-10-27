class Video < ActiveRecord::Base
	belongs_to :mem

  def created_at
    super.strftime('%Y-%m-%d')  if super
  end

  def updated_at
    super.strftime('%Y-%m-%d')  if super
  end

  def src_url
    Rails.application.config.qiniu_base + src
  end

  def preview_url
    if !preview.nil?
      Rails.application.config.qiniu_base + preview
    else
      ''
    end
  end

  def cover_url
    if cover[0..6] != 'http://'
      Rails.application.config.assets_base + 'video/' + cover.to_s
    else
      cover
    end
  end

  def self.list_field
    self.select('id,title')
  end 
  
end
