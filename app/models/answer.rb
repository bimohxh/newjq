class Answer < ActiveRecord::Base
  belongs_to :ask
  belongs_to :mem
  has_many :vote_logs, dependent: :destroy

  def friendly_time  
    created_at.friendly_i18n  
  end


  def update_vote
    _acts = self.vote_logs.pluck("act")
    self.votes = _acts.count{|m|m == 'UP'} * 2 -  _acts.count
    self.save
  end
  
  def self.list_field
    self.select('con')
  end 

  def raw_con
    _c = CGI::escapeHTML(con).gsub(/&lt;pre(.+?)&gt;/){ |m|
      "<pre #{CGI::unescapeHTML($1)}>"
    }.gsub(/&lt;\/pre&gt;/,'</pre>')
  end
  


end
