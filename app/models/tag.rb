class Tag < ApplicationRecord
    has_many :products_tags_rels
    has_many :products ,through: :product_tag_rels
end
