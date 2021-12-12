class AddDefault < ActiveRecord::Migration[6.1]
  def change
    change_column :products,:name,:string,:null=>false
    change_column :products,:user_id,:integer,:null=>false
    change_column :products,:price,:integer,:null=>false,:default=>0
    change_column :products,:quentity,:integer,:null=>false,:default=>0

    change_column :users,:name,:string,:null=>false
    change_column :users,:email,:string,:null=>false

    change_column :carts,:amount,:integer,:null=>false,:default=>1
    change_column :carts,:price,:integer,:null=>false
    change_column :carts,:user_id,:integer,:null=>false
    change_column :carts,:product_id,:integer,:null=>false

    change_column :trades,:state,:string,:null=>false,:default=>"start"
    change_column :trades,:detail,:text,:null=>false

    add_column :trades,:user_id,:integer,:null=>false


  end
end
