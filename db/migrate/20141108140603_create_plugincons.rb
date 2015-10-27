class CreatePlugincons < ActiveRecord::Migration
  def change
    create_table :plugincons,:options => 'CHARSET=utf8' do |t|
    	t.string :recsts,:limit=>1,:default=>1  
    	t.belongs_to :mem
    	t.text :con 
    	t.belongs_to :plugin 
      t.timestamps
    end
  end
end
