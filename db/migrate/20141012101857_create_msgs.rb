class CreateMsgs < ActiveRecord::Migration
  def change
    create_table :msgs,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0 
      t.string :content,:limit=>1000
      t.string :extra,:limit=>1000

      t.integer :from_id
      t.string :from_typcd,:limit=>20 
      t.integer :to_id
      t.string :to_typcd,:limit=>20

      t.timestamps
    end
  end
end
