class CreateThiefs < ActiveRecord::Migration
  def change
    create_table :thiefs,:options => 'CHARSET=utf8' do |t|
  	  t.string :recsts,:limit=>1,:default=>0
  	  t.string :server
  	  t.string :referer
  	  t.integer :num,:default=>1
      t.timestamps
    end
  end
end
