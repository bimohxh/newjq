class AddIndex < ActiveRecord::Migration
  def change
  	add_index("plugins","recsts")
  	add_index("plugins","typ")
  	add_index("plugins","root_typ")
  end
end
