class Product < ApplicationRecord
    belongs_to :user
    has_many :carts
    has_many :products_tags_rels
    has_many :tags ,through: :products_tags_rels

    has_many :coupons_products_tags_rels,as: :object



    def add_tag(tagName)
        code=0
        msg=""
        tag=Tag.find_by(name: tagName)
        unless tag
            tag=Tag.new(name: tagName)    
        end

        unless self.tags.include? tag
            self.tags<<tag
        else
            code=1
            msg='already exist'
        end

        return code,msg
    end

    def delete_tag(tagName)
        tag=self.tags.find_by(name: tagName)
        if tag
            self.tags.destroy(tag)
            code=0
            msg=""
        else
            code=1
            msg="tag not found"
        end
        return code,msg
    end


    def self.get_productsInfo_by_userId(id)
        products=Product.eager_load(:tags).where(user_id: id)

        return products.map {|p| p.as_json(include: {tags:{only: :name}},except: [:created_at,:updated_at])}
    end

    
    def self.update_products(user,products)
        msg=""
        code=0
        hashPorducts={}
        products.each do |p|
            hashPorducts[p[:id].to_i]=p #turn products from array to hash by id
        end
        
        myproducts=user.products
        myProductsName=myproducts.map {|p| p[:name]}

        myproducts.each do |myproduct|
            id=myproduct[:id]
            
            unless hashPorducts[id]
                next
            end

            if hashPorducts[id][:name] && hashPorducts[id][:name]!=myproduct[:name]  

                if myProductsName.include? hashPorducts[id][:name]      #check is name been taken
                    msg.concat " #{myproduct[:name]} can't chage to #{hashPorducts[id][:name]},"
                    code=2
                    next
                end
                myproduct[:name]=hashPorducts[id][:name]
                
            end

            if hashPorducts[id][:price] 
                myproduct[:price]=hashPorducts[id][:price]
            end

            if hashPorducts[id][:quentity]
                myproduct[:quentity]=hashPorducts[id][:quentity]
            end
            myproduct.save

            hashPorducts.delete(id)                
        end

        unless hashPorducts.empty?
            code=2
            keys=[]
            hashPorducts.each_key {|key| keys<<key}
            msg.concat "can't find ID:#{keys} in user's products"
        end

        return code,msg
    end

    
    def self.add_products(user,products)
        newProducts=[]
        msg=""
        code=0
        myproductnames=user.products.map {|p| p[:name]}

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

        user.products<<newProducts

        return code,msg
    end

    def self.delete_products(user,products)
        msg=""
        code=0

        myproducts=Product.where(id: products,user_id:user[:id])

        myproducts.each do |myproduct|
            myproduct.destroy

            products.delete(myproduct[:id].to_s)
        end

        unless products.empty?
            msg.concat "can't find ID:#{products} in user's products"
            code=2
        end
        
        return code,msg
    end


end
