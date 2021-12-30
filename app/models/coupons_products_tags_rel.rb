class CouponsProductsTagsRel < ApplicationRecord
    belongs_to :object,polymorphic: true
    belongs_to :coupon
end
