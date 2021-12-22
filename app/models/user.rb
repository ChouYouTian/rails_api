class User < ApplicationRecord
    has_many:products
    has_many:carts
    has_many:trades


    def delete_user
        begin 
            self.transaction do
                
                self.carts.each {|c| c.destroy!}
                self.products.each {|p| p.destroy!}
                self.trades.each {|t| t.destroy!}

                self.destroy!

            end
            return true
        rescue 
            return false
        end
    end
end
