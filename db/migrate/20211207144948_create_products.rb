class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|

      t.string:name
      t.integer:price
      t.integer:quentity
      t.integer:user_id

      t.timestamps
    end
  end
end
