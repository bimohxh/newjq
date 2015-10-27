class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows,:options => 'CHARSET=utf8' do |t|
      t.integer :from_id  #关注者ID
      t.integer :to_id #被关注者ID
      t.timestamps
    end
  end
end
