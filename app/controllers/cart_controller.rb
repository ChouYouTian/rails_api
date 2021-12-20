class CartController < ApplicationController
    before_action :autenticate_spa_user!

    def testCart
        # carts=Cart.joins("LEFT JOIN products on carts.product_id=products.id")
        carts=Cart.find_by_sql("select carts.id,carts.amount,carts.total_price,products.name from carts  left join products on carts.product_id=products.id where carts.user_id=#{@user.id}")

 
        puts carts
        render json: carts
    end

    

    def myCart
        carts=Cart.eager_load(:product).where(user_id: @user.id)

        if carts 

            output=[]
            
            carts.each do |cart|
    
                save=false
                cartinfo={}
                product=cart.product

                if product &&(cart[:product_user_id]==product[:user_id])

                    if cart[:amount]>product[:quentity] && cart[:state]=="active"
                        
                        cart[:msg]="數量不足"
                        cart[:state]="lack"
                        save=true
                    
                    elsif cart[:state]=="lack"
                        cart[:msg]=""
                        cart[:state]="active"
                        save=true
                    end

                    total_price=cart[:amount]*product[:price]
                    if cart[:total_price]!=total_price
                        cart[:total_price]=total_price 
                        save=true
                    end

                    cartinfo={:id=>cart[:id],:amount=>cart[:amount],:total_price=>cart[:total_price],:state=>cart[:state],:msg=>cart[:msg],:name=>product[:name],:price=>product[:price],:quentity=>product[:quentity]}

                else
                    if cart[:state]!="disable"
                        if  cart[:state]=="active" || cart[:state]=="lack"
                            cart[:msg]="商品不存在"
                            cart[:state]="disable"
                            save=true
                        elsif cart[:msg]==""
                            cart[:msg]="商品不存在"
                            save=true
                        end
                    end

                    cartinfo={:id=>cart[:id],:amount=>cart[:amount],:total_price=>cart[:total_price],:state=>cart[:state],:msg=>cart[:msg],:name=>nil,:price=>nil,:quentity=>nil}
                end
                
                if save
                    cart.save
                end

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
        product=Product.find_by(id: params[:product][:id])
        
        amount=params[:product][:amount].to_i
        if !amount
            amount=1            
        end


        if amount > product[:quentity]  #check product quntity
            render json:{:code=>1,:msg=>'Insufficient quantity'}

        elsif product
            cart=Cart.new()

            cart.user_id=@user[:id]
            cart.product_id=product[:id]
            cart.amount=amount
            cart.total_price=amount*product[:price]
            cart.product_user_id=product[:user_id]

            cart.save(validate: false)  #terrible
            
            render json:{:code=>0,:msg=>'cart added'}    
        else
            render json:{:code=>1,:msg=>'Did not find product'}
  
        end

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
        msg=""
        code=0
        if carts

            carts.each do |c|
          
                mycart=Cart.find_by(id: c["id"],user_id: @user[:id])
                amount=c[:amount]
                total_price=c[:total_price]
                save=false
                if mycart 
                    if amount
                        mycart[:amount]=amount
                        save=true
                    end
                    if total_price
                        mycart[:total_price]=total_price
                        save=true
                    end
                    if save
                        mycart.save(validate: false)         #terrible way to save
                    end

                else
                    msg.concat " cart:#{c[:id]} not in #{@user[:name]}\'s cart,"
                    code=2
                end
            end
            if code==0
                render json:{:code=>0,:msg=>'cart update'} 
            else
                render json:{:code=>2,:msg=>msg} 
            end
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
        msg=""
        code=0
        if carts
            mycarts=Cart.where(id:carts,user_id:@user[:id])

            mycarts.each do |mycart|
                mycart.destroy
                msg.concat "delete #{mycart.id}, "
    
            end
     
            
            render json:{:code=>code ,:msg=>msg}
        
        else
            render json:{:code=>1 ,:msg=>"{\"msg\":\"Did not find carts ,check params\"}"}
        end

    end
end
