class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :carts do |t|
      t.integer:amount
      t.integer:price
      t.integer:user_id
      t.integer:product_id

      t.timestamps
    end
  end
end
