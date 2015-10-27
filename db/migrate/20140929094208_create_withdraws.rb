class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>1  # 1 未处理  0 成功
      t.belongs_to :mem
      t.integer :num
      t.string :remark
      t.timestamps
    end
  end
end
