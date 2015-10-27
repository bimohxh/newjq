class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins,:options => 'CHARSET=utf8' do |t|
      t.belongs_to :mem
      t.timestamps null: false
    end
  end
end
