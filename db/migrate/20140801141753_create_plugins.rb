class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>1  
      t.string :title
      t.string :desc  
      t.string :keywords
      t.string :typ
      t.string :root_typ
      t.string :pic
      t.string :demo
      t.string :download
      t.integer :downnum,:default=>0
      t.string :website
      t.string :browser
      t.string :videos
      t.text :con  
      t.belongs_to :mem 
      t.integer :cost,:default=>0

      t.integer :visit,:default=>0
      t.integer :collect,:default=>0
      t.integer :comment,:default=>0 

      t.string :ischeck,:limit=>1,:default=>1
      t.timestamps
    end
  end
end
