class Coupon < ApplicationRecord
    belongs_to :user

    has_many :coupons_products_tags_rels
    has_many :tags ,through: :coupons_products_tags_rels,source: :object,source_type: "Tag"
    has_many :products ,through: :coupons_products_tags_rels,source: :object,source_type: "Product"
end
