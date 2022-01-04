class ChangeCouponsStartEnd < ActiveRecord::Migration[6.1]
  def change
    change_column_default :coupons,:start_time,nil
    change_column_default :coupons,:end_time,nil
  end
end
