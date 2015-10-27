class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>1
      t.string :title
      t.string :desc
      t.string :keywords
      t.string :typ
      t.text :con 
      t.string :src 
      t.string :cover 
      t.string :duration 
      t.belongs_to :mem 
      
      t.string :preview #预览视频
      t.integer :cost,:default=>0


      t.integer :visit,:default=>0
      t.integer :playnum,:default=>0
      t.integer :collect,:default=>0
      t.integer :comment,:default=>0
      t.string :ischeck,:limit=>1,:default=>1
      t.timestamps
    end
  end
end
