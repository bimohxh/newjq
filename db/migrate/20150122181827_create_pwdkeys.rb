class CreatePwdkeys < ActiveRecord::Migration
  def change
    create_table :pwdkeys,:options => 'CHARSET=utf8' do |t|
      t.belongs_to :mem
      t.string :key
      t.string :email
      t.timestamps null: false
    end
  end
end
