class AddCartsColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :carts,:trade_id,:integer
  end
end
