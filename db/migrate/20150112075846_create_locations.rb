class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations,:options => 'CHARSET=utf8' do |t|
      t.integer :cd
      t.string :code
      t.integer :parent
      t.string :nm
      t.string :nmen 
      t.timestamps null: false
    end
  end
end
