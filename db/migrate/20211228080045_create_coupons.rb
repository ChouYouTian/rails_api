class CreateCoupons < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons do |t|
      t.references :user

      t.string :name , :null=>false,:limit => 10,:index=>true
      t.string :user_type,:null=>false,:default=>"user"
    
      t.integer :amount,:null=>false,:default=>0

      t.string :discount_type,:null=>false,:default=>"price"
      t.integer :discount_amount,:null=>false,:default=>0
      t.integer :discount_ordinal,:null=>false,:default=>0

      t.date :start, :null=>false
      t.date :end,:null=>false

      t.string :state,:null=>false,:default=>"disable"


      t.timestamps
    end
  end

  create_table :users_coupons_rel ,id: false do |t|
    t.references :user
    t.references :coupon

    t.integer :amount,:null=>false,:default=>1

  end

end
