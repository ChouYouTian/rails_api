class UpdateProduct < ActiveRecord::Migration[6.1]
  def change
    change_column :products,:id,:integer,unique:true
  end
end
