class Ask < ActiveRecord::Base
  belongs_to :mem
  has_many :answers, dependent: :destroy

  def friendly_time  
    created_at.friendly_i18n  
  end

  def keywords
    super.nil? ? '' : super
  end

  def update_answer
    self.answer = self.answers.where({:typcd=> "ANSWER"}).count
    self.save
  end

  def self.list_field
    self.select('id,title,answer,collect,created_at,status,visit')
  end 

end
