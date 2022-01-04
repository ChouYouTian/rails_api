class RenameQuentity < ActiveRecord::Migration[6.1]
  def change
    rename_column :products,:quentity,:quantity
    rename_column :coupons,:quentity,:quantity
  end
end
