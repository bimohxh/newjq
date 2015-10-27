class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs,:options => 'CHARSET=utf8' do |t|
    	t.string :recsts,:limit=>1,:default=>0
    	t.string :typ
    	t.string :key 
    	t.integer :val1
    	t.string :val2
    	t.string :sdesc
    	t.text :fdesc 
      t.timestamps
    end
  end
end
