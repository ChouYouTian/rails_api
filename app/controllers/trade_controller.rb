class TradeController < ApplicationController
    before_action :autenticate_spa_user!


    def myTrade
        render json:@user.trades
    end


    #-----createTrade input example----
    # {
    #     "name":"test", #user name
    #     "carts":[10,...    ]         #cart id
    # }

    def create
        cartsId=params[:carts]
        
        if @user && cartsId
            detail=""
            totalPrice=0
            mycarts=Cart.where(id: cartsId)
            
            mycarts.each do |c|

                tempProduct=Product.find(c[:product_id])
                
                if tempProduct[:quentity]<c[:amount]
                    return render json:JSON.parse("{\"msg\":\"#{tempProduct[:name]} not enough \"}")
                end

                if c[:user_id]!=@user[:id]
                    return render json:JSON.parse("{\"msg\":\"#{c[:name]} is not in #{@user[:name]}'s cart \"}")
                end

                detail.concat "#{tempProduct[:name]}$#{tempProduct[:price]}* #{c[:amount]},"
                totalPrice+=tempProduct[:price]*c[:amount]
            end
            
            detail.concat "total price: #{totalPrice}"
            
            trade=Trade.new()
            trade[:detail]=detail
            trade.carts<<mycarts

            @user.trades<<trade
            
            render json:JSON.parse("{\"msg\":\"trade active\"}")
        elsif @user
            render json:JSON.parse("{\"msg\":\"Did not find carts,pls check params\"}")
        else
            render json:JSON.parse("{\"msg\":\"user not exsit\"}")
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
 
