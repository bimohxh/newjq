class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts,:options => 'CHARSET=utf8' do |t|
      t.belongs_to :mem
      t.string :title #标题
      t.string :content,:limit=>1000 #内容
      t.string :link #链接
      t.string :status,:default=>'UNREAD' #状态
      t.timestamps
    end
  end
end
