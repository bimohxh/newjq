class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins,:options => 'CHARSET=utf8' do |t|
      t.belongs_to :mem
      t.date :begdt
      t.date :enddt
      t.timestamps null: false
    end
  end
end
