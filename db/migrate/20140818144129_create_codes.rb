class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>1
      t.string :title
      t.string :desc
      t.string :keywords
      t.text :snippet

      t.text :shtml
      t.text :scss
      t.text :sjs
      
      t.text :con
      t.belongs_to :mem 

      t.integer :visit,:default=>0
      t.integer :collect,:default=>0
      t.integer :comment,:default=>0
      
      t.string :ischeck,:limit=>1,:default=>1
      
      t.timestamps
    end
  end
end
