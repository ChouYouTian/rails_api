class TradeController < ApplicationController
    before_action :autenticate_spa_user! , except:[:ecpayClientPage,:ecpayReturn]


    def myTrade
        render json:{:code=>0 ,:trades=>@user.trades ,:msg=>""} 
    end


    #-----createTrade input example----
    # {
    #     "carts":[10,...    ]         #cart id
    # }
    def create
        code,msg=Trade.create_trade(@user,params[:carts])
        
        render json:{'code'=>code,'msg':msg}
    end


    #-----ship input example----
    # {
    #     "trade":1        # id
    # }
    def ship
        trade=@user.trades.find(params[:trade])
        if trade
            trade.shipping!
            render json:{:code=>0,:mag=>""}
        else
            render json:{:code=>1,:mag=>"can't find trade in #{@user[:name]}'s trades'"}
        end
    end


    #-----finish input example----
    # {
    #     "trade":1        # id
    # }
    def finish
        trade=@user.trades.find(params[:trade])
        if trade
            trade.finish!
            render json:{:code=>0,:mag=>""}
        else
            render json:{:code=>1,:mag=>"can't find trade in #{@user[:name]}'s trades'"}
        end
    end
end
 
