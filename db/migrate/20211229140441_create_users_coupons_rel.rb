class CreateUsersCouponsRel < ActiveRecord::Migration[6.1]
  def change
    create_table :users_coupons_rels,:id=>false do |t|
      t.references :user,:index=>true
      t.references :coupon,:index=>true

      t.integer :amount ,:null=>false

      t.timestamps
    end
  end
end
