class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0
      t.string :typ
      t.integer :idcd
      t.belongs_to :mem
      t.timestamps
    end
  end
end
