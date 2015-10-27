class Mem < ActiveRecord::Base
  has_many :favorites, dependent: :destroy
  has_many :comments
  has_many :plugins
  has_many :codes
  has_many :videos
  has_many :mauths
  has_many :cards
  has_many :fund_records
  has_many :buylogs
  has_many :orders
  has_many :plugincons
  has_many :alerts
  has_one :checkin
  has_many :asks
  has_many :answers
  has_many :vote_logs
  has_one :mem_info
  has_one :admin
  
  attr_accessor :followstatus

  def enabeld?
    recsts == '0'
  end

  def created_at
    super.strftime('%Y-%m-%d')  if super
  end

  #def created_at
  #  super.strftime('%Y-%m-%d')  if super
  #end 

  def allow_show
    Mem.select("id,nc,photo").find(self.id)
  end

  def unread_alerts
    self.alerts.where({:status=>"UNREAD"})
  end

  def follow_mems
    _toids = Follow.where({:from_id=> id}).pluck('to_id')
    Mem.select(:photo,:nc,:id,:followers,:following).where({:id=>_toids})
  end

  def fans_mems
    _fromids = Follow.where({:to_id=> id}).pluck('from_id')
    Mem.select(:photo,:nc,:id,:followers,:following).where({:id=>_fromids})
  end

  def upload_following
    self.following = Follow.where({:from_id=> id}).count
    self.save
  end

  def upload_follower
    self.followers = Follow.where({:to_id=> id}).count
    self.save
  end

  def send_alerts con
    self.alerts.create({:content=> con})
  end

  def get_money num,remark
    self.integral += num
    self.fund_records.create({:num=> num,:balance=> self.integral,:remark=>remark})
    self.save
  end

  def give_money num,remark
    self.integral -= num
    self.fund_records.create({:num=> -num,:balance=> self.integral,:remark=>remark})
    self.save
  end

  def mem_info
    super || MemInfo.create(:mem_id=>id)
  end

end
