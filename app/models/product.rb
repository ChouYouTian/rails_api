class Product < ApplicationRecord
    belongs_to:user
    has_many:cart

    def get_info
        return {id: self[:id],name: self[:name],price: self[:price],quentity: self[:quentity]}
    end
end
