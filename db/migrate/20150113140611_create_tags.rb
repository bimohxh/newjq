class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags,:options => 'CHARSET=utf8' do |t|
      t.string :nm
      t.integer :num
      t.string :typcd,:default=> 'PLUGIN' #PLUGIN  CODE  VIDEO
      t.timestamps null: false
    end
  end
end
