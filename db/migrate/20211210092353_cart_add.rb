class CartAdd < ActiveRecord::Migration[6.1]
  def change
    add_column :carts,:state,:string,:default=>"active",:null=>false
    add_column :carts,:msg,:string
    add_column :carts,:product_user_id,:integer,:default=>-1,:null=>false
  end
end
