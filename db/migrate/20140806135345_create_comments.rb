class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments,:options => 'CHARSET=utf8' do |t|
    	t.string :recsts,:limit=>1,:default=>0
    	t.string :typ
    	t.integer :idcd
    	t.belongs_to :mem
    	t.text :con 
      t.timestamps
    end
  end
end
