class UpdateCoupon < ActiveRecord::Migration[6.1]
  def change
    drop_table :coupons
    drop_table :users_coupons_rel
  end
end
