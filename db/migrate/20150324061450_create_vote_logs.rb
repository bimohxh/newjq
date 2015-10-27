class CreateVoteLogs < ActiveRecord::Migration
  def change
    create_table :vote_logs,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0
      t.belongs_to :answer
      t.belongs_to :mem
      t.string :act #UP  DOWN
      t.timestamps null: false
    end
  end
end
