class UpdateUsersCoupon < ActiveRecord::Migration[6.1]
  def change
    rename_table :users_coupons_rels,:userscoupons 
  end
end
