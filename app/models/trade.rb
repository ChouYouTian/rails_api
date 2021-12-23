class Trade < ApplicationRecord
    belongs_to:user

    has_many:carts

    def fail!
        self[:state]='fail'
        self.save
    end

    def cancel!
        self[:state]='cancel'
        
        self.carts do |cart|
            cart.cancel!
        end
        
        self.save
    end
    
    def finish!
        self[:state]='finish'
        self.save
    end
    
    def paying!
        self[:state]='paying'
        self.save
    end

    def paid!
        self[:state]='paid'
        self.save
    end

    def  shipping!
        self[:state]='shipping'
        self.save
    end

    def self.create_trade(user,cartsId)
        
        carts=Cart.eager_load(:product).where(id: cartsId,user_id: user.id)

        if cartsId.size()==carts.size()
            detail=""
            code=0
            msg=""
            totalPrice=0

            begin
                Cart.transaction do
                    trade=Trade.new()

                    carts.each do |cart|
                        product=cart.product

                        if !product
                            msg.concat "cartid:#{cart[:id]} product not exist"
                            raise
                        elsif product[:quentity]<cart[:amount]
                            msg.concat "#{product[:name]} not enough"
                            raise
                        elsif cart[:state]!="active" && cart[:state]!="lack"
                            msg.concat "cartid:#{cart[:id]} state error"
                            raise
                        end
                        
                        detail.concat "#{product[:name]} $#{product[:price]}* #{cart[:amount]}," 
                        totalPrice+=product[:price]*cart[:amount]

                        cart[:state]="intrade"
                        product[:quentity]= product[:quentity]-cart[:amount]

                        product.save
                        trade.carts<<cart
                    end
                    
                    detail.concat "total price: #{totalPrice}"
                    trade.update(detail: detail,total_price: totalPrice)
                    user.trades<<trade
                    CheckTradeJob.set(wait: 10.seconds).perform_later(trade[:id])
                end
              
                code=0
                msg="trade created"
            
            rescue
                code=1
                msg="fail. #{msg}"
            end
        else
            code=1
            msg="cart missing"
        end

        return code,msg
    end


end
