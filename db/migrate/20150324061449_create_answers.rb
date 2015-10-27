class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers,:options => 'CHARSET=utf8' do |t|
      t.string :recsts,:limit=>1,:default=>0
      t.belongs_to :ask
      t.belongs_to :mem
      t.integer :votes,:default=>0
      t.text :con
      t.string :typcd,:default=>'ANSWER' # ANSWER  REPLY
      t.integer :parent,:default=>0

      t.timestamps null: false
    end
  end
end
