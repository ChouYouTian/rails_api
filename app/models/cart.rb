class Cart < ApplicationRecord
    belongs_to:user  
    belongs_to:product
    belongs_to:trade

    def intrade!
        self[:state]="intrade"
        self.save
    end

    def cancel!
        self[:state]="cancel"
        self.save
    end
    
    def fail!
        self[:state]="fail"
        self.save
    end

    def finish!
        self[:state]='finish'
        self.save
    end

    def get_cart_info
        save=false
        selfinfo={}
        product=self.product

        if product &&(self[:product_user_id]==product[:user_id]) #檢查product的user id是否相同，避免product刪除後id重複

            if self[:amount]>product[:quentity]
                if self[:state]=="active"
                    self[:msg]="數量不足"
                    self[:state]="lack"
                    save=true
                end
            elsif self[:state]=="lack"
                self[:msg]=""
                self[:state]="active"
                save=true
            end

            total_price=self[:amount]*product[:price]
            if self[:total_price]!=total_price
                self[:total_price]=total_price 
                save=true
            end

            selfinfo={:id=>self[:id],:amount=>self[:amount],:total_price=>self[:total_price],:state=>self[:state],:msg=>self[:msg],:name=>product[:name],:price=>product[:price],:quentity=>product[:quentity]}

        else
            if self[:state]!="disable"
                if  self[:state]=="active" || self[:state]=="lack"
                    self[:msg]="商品不存在"
                    self[:state]="disable"
                    save=true
                elsif self[:msg]==""
                    self[:msg]="商品不存在"
                    save=true
                end
            end

            selfinfo={:id=>self[:id],:amount=>self[:amount],:total_price=>self[:total_price],:state=>self[:state],:msg=>self[:msg],:name=>nil,:price=>nil,:quentity=>nil}
        end
        
        if save
            self.save
        end

        return selfinfo
    end

end
