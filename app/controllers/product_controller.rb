class ProductController < ApplicationController
    before_action :autenticate_spa_user! ,only: [:addProducts,:updateProducts,:deleteProducts]

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
        # provider=User.find_by(id: params[:id])
        products=Product.where(user_id: params[:id])
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

        # render json:provider.products
        render json:{
            :code=>0,
            :products=>products
        }
        
    end

    #-----addProducts input example----
    # {
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

        products=params[:products]
        msg=""
        code=0

        if @user && products
            newProducts=[]
            myproductnames=@user.products.map {|p| p[:name]}

            products.each do |p|
                if myproductnames.include? p[:name]  #check is product exist
                    msg.concat " #{p[:name]} product allready exsit,"
                    code=2
                    next
                end

                np=Product.new(name: p[:name]) #new product

                price=p[:price]
                quentity=p[:quentity]

                if price
                    np[:price]=price
                end
                if quentity
                    np[:quentity]=quentity
                end

                newProducts<<np
                msg.concat " #{p[:name]} product added,"
            end

            @user.products<<newProducts

            
            if code==0
                render json:{
                    :code=>code,
                    :msg=>"products created"
                }
            else
                render json:{
                    :code=>code,
                    :msg=>"#{msg}"
                }
            end

       
        else
            render json:{
                :code=>1,
                :msg=>"fail,pls check your params,"
            }
        end
    end


    #-----updateProducts input example----
    # {
    #     "name":"test", #user name
    #     "products":[
    #                  {
    #                    "id":1 #product id
    #                    --"name":"new productname", #new product name
    #                    --"price":20,          #new product price 
    #                    --"quentity":20        #new product quentity 
    #                   },
    #         {
    #           ...
    #         }
    #     ]
    # }
    def updateProducts

        products=params[:products]
        msg=""
        code=0

        if products

            pids=[]
            hashPorducts={}

            products.each do |p|
                pids<<p[:id]
                hashPorducts[p[:id].to_i]=p #tern products from array to hash by id

            end
   

            myproducts=Product.where(id: pids,user_id: @user[:id])

            myProductsName=@user.products.map {|p| p[:name]}

            myproducts.each do |p|
                id=p[:id]

                if hashPorducts[id][:name] && hashPorducts[id][:name]!=p[:name]  #check is name been taken
                    if myProductsName.include? hashPorducts[id][:name]
                        msg.concat " #{p[:name]} can't chage to #{hashPorducts[id][:name]},"
                        code=2
                    else
                        p[:name]=hashPorducts[id][:name]
                    end
                end
                if hashPorducts[id][:price] 
                    p[:price]=hashPorducts[id][:price]
                end
                if hashPorducts[id][:quentity]
                    p[:quentity]=hashPorducts[id][:quentity]
                end
                p.save
                    
            end
            
            if code==0
                render json:{
                    :code=>code,
                    :msg=>"update products"
                }
            else
                render json:{
                    :code=>code,
                    :msg=>"#{msg}"
                }
            end
        else
            render json:{
                :code=>1,
                :msg=>"Params error"
            }
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
