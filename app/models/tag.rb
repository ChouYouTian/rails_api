class Tag < ApplicationRecord
    has_many :product_tag_rels
    has_many :products ,through: :product_tag_rels
end
