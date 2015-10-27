class CreateRefcds < ActiveRecord::Migration
  def change
    create_table :refcds,:options => 'CHARSET=utf8' do |t|
      t.string :cd
      t.string :key
      t.string :sdesc
      t.string :var1 #附加值1
      t.string :var2 #附加值2
      t.integer :var3 

      t.timestamps null: false
    end
  end
end
