class CreateMems < ActiveRecord::Migration
  def change
    create_table :mems,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0 
      
      t.string :nc
      t.string :photo
      t.integer :integral,:default=>0
      t.string :gender,:limit=>1,:default=>'M'
      t.string :email
      t.string :email_valid,:default=>'NO' #是否验证邮箱 YES
      t.string :pwd


      t.integer :plugin,:default=>0
      t.integer :code,:default=>0
      t.integer :video,:default=>0

      t.integer :favorp,:default=>0
      t.integer :favorc,:default=>0
      t.integer :favorv,:default=>0
      t.integer :favorask,:default=>0

      t.integer :followers,:default=>0   #粉丝数量
      t.integer :following,:default=>0  #关注别人的数量

      t.integer :ask,:default=>0
      t.integer :answer,:default=>0

      t.timestamps
    end
  end
end
