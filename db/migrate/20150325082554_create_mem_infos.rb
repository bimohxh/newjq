class CreateMemInfos < ActiveRecord::Migration
  def change
    create_table :mem_infos,:options => 'CHARSET=utf8' do |t| 

      t.belongs_to :mem
      t.string :gender 
      t.string :dob
      t.string :city #城市

      t.timestamps null: false
    end
  end
end
