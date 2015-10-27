class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0
      t.string :no
      t.belongs_to :mem
      t.string :price      
      t.string :remark
      t.string :state
      t.string :issend,:limit=>1,:default=>0 #0 未发货 1 已发货
      t.timestamps
    end
  end
end
