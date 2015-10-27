class CreateFundRecords < ActiveRecord::Migration
  def change
    create_table :fund_records,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0
      t.belongs_to :mem
      t.integer :num
      t.integer :balance
      t.string :remark
      t.timestamps
    end
  end
end
