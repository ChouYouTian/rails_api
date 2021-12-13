class CartController < ApplicationController
    before_action :autenticate_spa_user!


    def myCart

        # @user=User.find_by(name: params[:name])
        carts=@user.carts
        productlist=carts.map {|c| c[:product_id]}

        products=Product.where(id: productlist)
        
        phash={}
        products.each do |p|
            phash[p[:id]]=p
        end

        carts.each do |c|
            tempP=phash[c[:product_id]]
   

            if tempP
                if c[:product_user_id]!=tempP[:user_id] && c[:product_user_id]!=-1
                    c[:state]="disable"
                    c[:msg]="商品不存在"
                    c.save
                else
                    if c[:product_user_id]==-1
                        c[:product_user_id]=tempP[:user_id]
                        c.save
                    end

                    if c[:amount]>tempP[:quentity]
                        c[:msg]="數量不足"
                        c.save
                    elsif c[:msg]
                        c[:msg]=""
                        c.save
                    end
                end
            else
                c[:state]="disable"
                c[:msg]="商品不存在"
                c.save
            end

        end


        render json:carts
    end


    #-----addToCart input example----
    # {
    #     "name":"test", #user name
    #     "product":{
    #                "id": 10             #cart id
    #              --"amount":20,          #cart amount default 1
    #               }
    #     
    # }
    def addToCart
 

        @product=Product.find_by(id: params[:product][:id])
        
        amount=params[:product][:amount]
        if !amount
            amount=1            
        end

        if amount>@product[:quentity]  #check product quntity
            render json:JSON.parse("{\"msg\":\"Insufficient quantity\"}")

        elsif @user && @product
            cart=Cart.new()

            cart.user_id=@user[:id]
            cart.product_id=@product[:id]
            cart.amount=amount
            cart.price=amount*@product[:price]
            cart[:product_user_id]=@product[:user_id]

            @user.carts<<cart


            render json:JSON.parse("{\"msg\":\"Added to cart\"}")
        elsif @user
            render json:JSON.parse("{\"msg\":\"Did not find product\"}")
        else
            render json:JSON.parse("{\"msg\":\"user not exsit\"}")
        end

    end


    #-----updateCarts input example----
    # {
    #     "name":"test", #user name
    #     "carts":[{
    #                "id": 10             #cart id
    #              --"amount":20,          #cart amount 
    #               },
    #               {
    #               ...
    #               }
    #             ]
    #     
    # }
    def updateCarts
        carts=params[:carts]
        msg=""
        if carts

            cartAtt=Cart.attribute_names()
            carts.each do |c|
          
                @mycart=Cart.find_by(id: c["id"],user_id: @user[:id])
                amount=c[:amount]

                if @mycart && amount
                    @mycart[:amount]=amount
                    @mycart.save
                elsif amount
                    msg.concat " cart:#{c[:id]} not in #{@user[:name]}\'s cart,"
                end
            end

            render json:JSON.parse("{\"msg\":\"Update cart\" #{msg} }")
        else
            render json:JSON.parse("{\"msg\":\"Did not find carts ,check params\"}")
        end

    end


    #-----deleteCarts input example----
    # {
    #     "name":"test", #user name
    #     "carts":[10,...    ]         #cart id
    # }
    def deleteCarts
        carts=params[:carts]
        msg=""
        if carts

            carts.each do |c|
          
                @mycart=Cart.find_by(id:c,user_id:@user[:id])

                if @mycart
                    @mycart.destroy
                    msg.concat "delete #{@mycart.id}, "
                else
                    msg.concat "can't find #{c} in #{@user[:name]}'s cart, "
                end
            end
            
            render json:JSON.parse("{\"msg\":\"#{msg}\"}")
        else
            render json:JSON.parse("{\"msg\":\"Did not find carts ,check params\"}")
        end

    end
end
