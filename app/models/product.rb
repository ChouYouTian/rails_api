class Product < ApplicationRecord
    belongs_to:user
    has_many:cart

    def get_info
        return {id: self[:id],name: self[:name],price: self[:price],quentity: self[:quentity]}
    end

    def self.get_products_by_userId(id)
        products=Product.where(user_id: id)
        products_info=[]

        products.each do |product|
            products_info<<product.get_info
        end

        return products_info
    end

end
