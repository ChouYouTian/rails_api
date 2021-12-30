class Tag < ApplicationRecord
    has_many :products_tags_rels
    has_many :products ,through: :products_tags_rels
    
    has_many :coupons_products_tags_rels,as: :object
end
