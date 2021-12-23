class CartController < ApplicationController
    before_action :autenticate_spa_user!

    def testCart
        carts=Cart.find_by_sql("select carts.id,carts.amount,carts.total_price,products.name from carts  left join products on carts.product_id=products.id where carts.user_id=#{@user.id}")
 
        puts carts
        render json: carts
    end

    
    def myCart
        carts=Cart.eager_load(:product).where(user_id: @user.id)

        if carts 
            output=[]
            
            carts.each do |cart|
    
               cartinfo=cart.get_cart_info

                output<<cartinfo
            end

            render json:{:code=>0, :carts=>output ,:msg=>""}
        else            
            render json:{:code=>0, :carts=>[] ,:msg=>"cart is empty"}
        end

    end


    #-----addToCart input example----
    # {
    #     "product":{
    #                "id": 10             #cart id
    #              --"amount":20,          #cart amount default 1
    #               }
    #     
    # }
    def addToCart

        code,msg=Cart.create_cart(@user,params[:product][:id],params[:product][:amount])

        render json:{:code=>code,:msg=>msg}
    end


    #-----updateCarts input example----
    # {
    #     "carts":[{
    #                "id": 10             #cart id
    #              --"amount":20,          #cart amount 
    #              --"total_price":200,          #cart total_price 
    #               },
    #               {
    #               ...
    #               }
    #             ]
    #     
    # }
    def updateCarts
        carts=params[:carts]
        
        code,msg=Cart.update_carts(@user,carts)

        if code==0
            render json:{:code=>0,:msg=>'cart updated'}
        elsif code==2
            render json:{:code=>2,:msg=>msg} 
        else
            render json:{:code=>1,:msg=>'Did not find carts ,check params'} 
        end
    end


    #-----deleteCarts input example----
    # {
    #     "carts":[10,...    ]         #cart id
    # }
    def deleteCarts
        carts=params[:carts]
        
        code,msg=Cart.delete_carts(@user,carts)

        render json:{:code=>code,:msg=>msg}
    end
end
