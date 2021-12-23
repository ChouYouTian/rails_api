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

    def self.get_provider
        providers=User.all
        plist=[]

        providers.each_with_index do |p,i|
            plist<<{"name":p[:name],"id":p[:id]}
        end
        return plist
    end


end
