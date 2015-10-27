class CreateMauths < ActiveRecord::Migration
  def change
    create_table :mauths,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0
      t.belongs_to :mem

      t.string :provider
      t.string :uid
      t.timestamps
    end
  end
end
