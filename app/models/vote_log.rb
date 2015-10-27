class VoteLog < ActiveRecord::Base
  belongs_to :mem
  belongs_to :answer
end
