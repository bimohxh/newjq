class CreateAsks < ActiveRecord::Migration
  def change
    create_table :asks,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>1
      t.string :title
      t.string :keywords
      t.text :con
      t.belongs_to :mem 
      t.integer :money,:default=>0 
      t.integer :adopt_cd  #采纳的答案ID
      t.string :status,:default=>'UNSOLVE'  #已解决 UNSOLVE 未解决 SOLVED

      t.integer :visit,:default=>0
      t.integer :collect,:default=>0
      t.integer :answer,:default=>0  #回答数

      t.timestamps null: false
    end
  end
end
