class CreateCouponsProductsTagsRels < ActiveRecord::Migration[6.1]
  def change
    create_table :coupons_products_tags_rels ,:id=>false do |t|
      t.references :coupon,index: true
      t.references :object, polymorphic: true, index: true

    end
  end
end
