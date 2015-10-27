class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0
      t.string :key
      t.string :pwd
      t.integer :cost
      t.integer :val
      t.belongs_to :mem
      t.string :used,:limit=>1,:default=>0
      t.timestamps
    end
  end
end
