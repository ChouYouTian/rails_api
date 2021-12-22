class ProductController < ApplicationController
    before_action :autenticate_spa_user! ,only: [:addProducts,:updateProducts,:deleteProducts]

    def getProviders
        plist=User.get_provider

        render json:{
            :code=>0,
            :providers=>plist
        }
    end

     #-----getProducts output example----
    #  {
    #      "products":[
    #          {
    #              "id":1,
    #              "name":'productname',
    #              "price":20,
    #              "quentity":100
    #          },
    #          {...}
    #      ]
    #  }
    def getProducts
        products_info=Product.get_products_by_userId(params[:id])

        render json:{
            :code=>0,
            :products=>products_info
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

        if products
           code,msg=Product.add_products @user,products
            
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
   
        if products
            code,msg=Product.update_products @user,products
            
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
    #     "products":[1...] #product id (int)
    # }
    def deleteProducts

        products=params[:products]

        if products

            code,msg=Product.delete_products @user,products

            if code==0
                render json:{
                    :code=>code,
                    :msg=>"products deleted"
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
                :msg=>"Did not find products,pls check your params"
            }
        end
    end

end
