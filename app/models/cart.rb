class Cart < ApplicationRecord
    belongs_to :user  
    belongs_to :product
    belongs_to :trade

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

    def self.create_cart(user,proudct_id,amount)
        code=0
        msg=""

        product=Product.find_by(id: proudct_id)

        if product
            cart=Cart.new()

            cart.user_id=user[:id]
            cart.product_id=product[:id]
            cart.amount=amount
            cart.total_price=amount*product[:price]
            cart.product_user_id=product[:user_id]

            cart.save(validate: false)  #terrible

        else
            code=1
            msg='Did not find product'
        end

        return code,msg
    end

    def self.update_carts(user,carts)
        msg=""
        code=0

        hashCarts={}
        cid=[]
        carts.each do |cart|
            cid<<cart[:id].to_i
            hashCarts[cart[:id]]=cart
        end

        mycarts=Cart.where(id: cid,user_id: user[:id])

        mycarts.each do |mycart|
            cart=hashCarts[mycart[:id].to_s]

            if cart[:amount]
                mycart[:amount]=cart[:amount]
                mycart.save(validate: false)         #terrible way to save
                cid.delete(mycart[:id])
            end
        end

        unless cid.empty?
            code=2
            msg.concat " cartid:#{cid} not in #{user[:name]}\'s cart,"
        end

        return code,msg
    end

    def self.delete_carts(user,carts)
        msg=""
        code=0
        
        mycarts=user.carts.where(id: carts)

        if mycarts.size == carts.size

            begin
                Cart.transaction do 
                    mycarts.each {|mycart| mycart.destroy }
                end
            rescue
                code=2
                msg="something goes wrong ,try later"
            end
        else
            code=1
            msg="can't find all carts in #{user[:name]}'s carts"
        end

        return code,msg
    end

    
end
