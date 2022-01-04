class ChangeCoupon < ActiveRecord::Migration[6.1]
  def change
    add_column :coupons,:description,:string,:null=>false
    rename_column :coupons ,:amount,:quentity
  end
end
