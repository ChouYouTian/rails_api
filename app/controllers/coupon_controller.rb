class CouponController < ApplicationController
    before_action :autenticate_spa_user!

    def test
        p params
        
    end

    
    #-----createCoupon input example----
    # {
    #             "name":"AxF3s2", #coupon name (string 10)
    #           --"qu:quantity":10 , #default 0
    #           --"discount_type":"price" #"price" or "percentage" ,default price
    #           --"discount_amount":10 #if type equal to "price" it should less then product price or it will set to product price
    #                                   #else if type equal to "percentage" it must in 0-100
    #           --"discount_minimum":3 #minimum amount of products which fit condition. default 1
    #           --"discount_ordinal":2 #which product to have discount,it must less then discount_amount.default 0 means all
    #           --"start":"2021-12-22 12:30" #start datetime,default now
    #           --"end":"2021-12-24 12:30" #end datetime,default one month later
    #           --"products":[10,2,24] #id of products
    #           --"tags":["tag1","tag2"...] #tags name
    #
    # }
    def createCoupon
        code=0
        msg=""
        
        if Coupon.find_by(name: params[:name],active: true)
            code=1
            msg="Coupon name has been taken"
        else
            coupon=Coupon.new(name: params[:name])

            if params[:quantity]
                coupon[:quantity]=params[:quantity]
            else
                coupon[:quantity]=0
            end

            if params[:discount_type]
                coupon[:discount_type]=params[:discount_type]
            else
                coupon[:discount_type]="price"
            end

            if params[:discount_amount]
                coupon[:discount_amount]=params[:discount_amount]
            else
                coupon[:discount_amount]=1
            end

            if params[:discount_ordinal]
                coupon[:discount_ordinal]=params[:discount_ordinal]
            else
                coupon[:discount_ordinal]=0
            end

            time=Datetime.now

            if params[:start]
                time=Datetime.parse params[:start]
                coupon[:start_time]=time
            else
                coupon[:start_time]=time
            end

            if params[:end]
                coupon[:end_time]=Datetime.parse params[:end]
            else
                coupon[:end_time]=time+1.months
            end

            if params[:products]
                products=Product.where(id: params[:products])
                coupon.products<<products
            end

            if params[:tags]
                tags=Tag.where(name: params[:tags])
                coupon.tags<<tags                
            end

            @user.coupons<<coupons


        end

        render json:{
            :code=>code,
            :coupons=>msg
        }  



    end

    def getCoupons
        render json:{
            :code=>0,
            :coupons=>@user.coupons
        }        
    end

    def getUsersCoupons
        render json:{
            :code=>0,
            :coupons=>@user.userscoupons
        }    
    end

    

end
