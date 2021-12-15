class ChangeCartColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :carts, :price, :total_price
  end
end
