class TradeController < ApplicationController
    before_action :autenticate_spa_user!


    def myTrade

        render json:{:code=>0 ,:trades=>@user.trades ,:msg=>""} 
    end


    #-----createTrade input example----
    # {
    #     "carts":[10,...    ]         #cart id
    # }

    def create
        cartsId=params[:carts]

        carts=Cart.eager_load(:product).where(id: cartsId,user_id: @user.id)

        if cartsId.length()==carts.length()
            detail=""
            code=0
            msg=""
            totalPrice=0

            begin
                Cart.transaction do
                    carts.each do |cart|
                        product=cart.product
                        
                        if product[:quentity]<cart[:amount]
                            msg.concat "#{product[:name]} not enough"
                            raise
                        elsif cart[:state]!="active"
                            msg.concat "cartid:#{cart[:id]} state error"
                            raise
                        end
                        
                        detail.concat "#{product[:name]}$#{product[:price]}* #{cart[:amount]},"
                        totalPrice+=product[:price]*cart[:amount]

                        cart[:state]="intrade"
                        product[:quentity]-=cart[:amount]

                        product.save()
                        cart.save()
                    end
                    
                    detail.concat "total price: #{totalPrice}"
                    
                    trade=Trade.new()
                    trade[:detail]=detail
                    trade[:total_price]=totalPrice
                    trade.carts<<carts
            
                    @user.trades<<trade
                end

                render json:{:code=>0 ,:msg=>"trade created"}
                
            rescue
                render json:{:code=>1 ,:msg=>"fail. #{msg}"}
            end
        else
            render json:{:code=>1 ,:msg=>"cart missing"}
        end
        
        
 
    end

    # {
    #     "id":1
    # }

    def update
        @trade=Trade.find(params[:id])
        state=params[:state]

        if @trade
            @trade[:state]=state
        else
            render json:JSON.parse("{\"msg\":\"trade not exsit\"}")
        end

        
    end

    def finish
        @trade=Trade.find(params[:id])


        if @trade
            @trade[:state]="finished"
        else
            render json:JSON.parse("{\"msg\":\"trade finish\"}")
        end
    end
end
 
