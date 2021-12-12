class ProductController < ApplicationController

    def getProviders
        providers=User.all
        len=providers.length()-1
        json="{\"providers\":["

        providers.each_with_index do |p,i|
            json.concat "\"#{p.name}\""
            if i!=len
                json.concat ","
            end
        end

        json.concat "]}"

        render json:JSON.parse(json)
    end

    def getProducts
        providers=User.find_by(name: params[:name])
        # len=providers.products.length()

        # json="{\"products\":["

        # providers.products.each_with_index  do |p,i|
        #     if i!=0 && len!=1
        #         json.concat ","
        #     end
        #     json.concat "\"#{p.name}\""
        # end

        # json.concat "]}"

        # render json:JSON.parse(json)

        render json:providers.products
        
    end

    #-----addProducts input example----
    # {
    #     "name":"test", #user name
    #     "products":[
    #         {
    #             "name":"testproduct", #product name
    #             --"price":20,          #product price default 0
    #             --"quentity":20        #product quentity default 0
    #         },
    #         {
    #           ...
    #         }
    #     ]
    # }
    def addProducts
        @user=User.find_by(name: params[:name])

        products=params[:products]
        msg=""

        if @user && products
            newProducts=[]
            myproductnames=@user.products.map {|p| p[:name]}

            products.each do |p|
                if myproductnames.include? p[:name]  #check is product exist
                    msg.concat " #{p[:name]} product allready exsit,"
                    next
                end

                np=Product.new(name: p[:name])

                price=p[:price]
                quentity=p[:quentity]

                if price
                    np[:price]=price
                end
                if quentity
                    np[:quentity]
                end

                newProducts<<np
                msg.concat " #{p[:name]} product added,"
            end

            @user.products<<newProducts

            render json:JSON.parse("{\"msg\":\"add products #{msg}\"}")

        elsif @user
            render json:JSON.parse("{\"msg\":\"Did not find products,pls check your params\"}")
        else
            render json:JSON.parse("{\"msg\":\"user not exsit\"}")
        end
    end


    #-----updateProducts input example----
    # {
    #     "name":"test", #user name
    #     "products":{
    #                  "productname":{
    #                                   --"name":"new productname", #new product name
    #                                   --"price":20,          #new product price 
    #                                   --"quentity":20        #new product quentity 
    #                                 },
    #         {
    #           ...
    #         }
    #     }
    # }
    def updateProducts
        @user=User.find_by(name: params[:name])

        products=params[:products]
        msg=""

        if @user && products
            
            userProductsName=@user.products.map {|p| p[:name]}
            
            products.keys.each do |k| #check is product in users products ,if not then delete from products(hash)
                if !userProductsName.include? k
                    msg.concat " #{k} product not exsit"
                    products.delete(k)
                end
            end
  
            attName= Product.attribute_names()
            
            @user.products.each do |p|
                setting=products[p[:name]]  #get produt setting by users product name 
                                            #  if not in products(hash) return null
                if setting
                    setting.each do |k,v|
                        if !attName.include? k  # check setting's attribute
                            msg.concat " #{p[:name]} has no attribute #{k},"
                            break

                        elsif k=="name"
                            unless userProductsName.include? v  #check is product name been used 
                                p[:name]=v
                            else
                                msg.concat " #{p[:name]} can't chage to #{v},"
                                break
                            end
                        else
                            p[k]=v
                        end
                    end
    
                    p.save
                    
                end
            end

            render json:JSON.parse("{\"msg\":\"update products #{msg}\"}")

        elsif @user
            render json:JSON.parse("{\"msg\":\"Did not find products,pls check your params\"}")
        else
            render json:JSON.parse("{\"msg\":\"user not exsit\"}")
        end
    end
    
    #-----deleteProducts input example----
    # {
    #     "name":"test", #user name
    #     "products":[1...] #product id
    # }
    def deleteProducts
        @user=User.find_by(name: params[:name])

        products=params[:products]
        msg=""

        if @user && products
 
            products.each do |p|
                myproduct=Product.find_by(id: p,user_id: @user[:id])
                if myproduct
                    myproduct.destroy
                    msg.concat "delete #{myproduct[:id]}, "
                else
                    msg.concat "can't find #{p} in #{@user[:name]}'s cart,"
                end
            end

            render json:JSON.parse("{\"msg\":\"delete products #{msg}\"}")

        elsif @user
            render json:JSON.parse("{\"msg\":\"Did not find products,pls check your params\"}")
        else
            render json:JSON.parse("{\"msg\":\"user not exsit\"}")
        end
    end

end
