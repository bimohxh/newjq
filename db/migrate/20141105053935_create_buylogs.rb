class CreateBuylogs < ActiveRecord::Migration
  def change
    create_table :buylogs,:options => 'CHARSET=utf8' do |t|
      t.string :typ
      t.integer :idcd  
      t.belongs_to :mem
      t.timestamps
    end
  end
end
