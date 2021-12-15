class UsersController < ApplicationController
    before_action :autenticate_spa_user! ,only: [:delete]
    
    def index
        render plain:"success"
    end

    def login
        @user=User.find_by(name:params[:name])

        if @user
            session[:user_id] = @user.id
            # render plain:"#{@user[:id]} #{@user[:name]}"
            render json:{
                :code=>0,
                :user_id=>@user[:id],
                :user_name=>@user[:name]
            }
        else
            render json:{
                :code=>1,
                :msg=>"not found ,pls check user name or email"   
            }
        end
    end

    def logout
        if session[:user_id]
            session.delete(:user_id)
            render json:{
                :code=>0,
                :msg=>"Logout"   
            }
        else
            render json:{
                :code=>1,
                :msg=>"user not found"   
            }
        end
    end



    def signup
        @user=User.find_by(email: params[:email])
        email=params[:email]
        name=params[:name]

        if @user
            render json:{
                :code=>1,
                :msg=>"User already exist" 
            }
        elsif email && name

            @user=User.new
            @user.name=params[:name]
            @user.email=params[:email]

            if @user.save
                render json:{
                    :code=>0,
                    :msg=>"success" 
                }
            else
                render json:{
                    :code=>1,
                    :msg=>"Fail,pls try again" 
                }
            end
        else
            render json:{
                :code=>1,
                :msg=>"Params error"
            }
        end

    end

    def delete
        
        begin 
            @user.transaction do
                
                @user.carts.each {|c| c.destroy!}
                @user.products.each {|p| p.destroy!}
                @user.trades.each {|t| t.destroy!}

                @user.destroy!

            end
            render json:{
                :code=>0,
                :msg=>"Success"
            }
        rescue 
            render json:{
                :code=>1,
                :msg=>"fail"
            }
        end

    end




 
end
