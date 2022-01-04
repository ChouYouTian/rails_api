class ChangeCoupons < ActiveRecord::Migration[6.1]
  def change
    rename_column :coupons ,:user_type,:coupon_type

    remove_column :coupons ,:state
    add_column :coupons ,:active ,:boolean,null: false ,default: true

    change_column_default :coupons,:start,from: nil ,to: Time.now
    change_column_default :coupons,:end,from: nil ,to: Time.now

    rename_column :coupons,:start,:start_time
    rename_column :coupons,:end,:end_time

  end
end
