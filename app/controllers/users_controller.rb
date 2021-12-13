class UsersController < ApplicationController
    def index
        render plain: "success"
    end

    def login
        @user=User.find_by(name:params[:name])

        if @user
            session[:user_id] = @user.id
            render plain:"#{@user[:id]} #{@user[:name]}"
        else
            render plain:"not found ,pls signup"
        end
    end

    def logout
        if session[:user_id]
            session.delete(:user_id)
            render plain:"logout"
        else
            render plain:"not found ,pls login"
        end
    end



    def signup
        @user=User.find_by(email: params[:email])
        email=params[:email]
        name=params[:name]

        if @user
            render plain:"Already exist" 
        elsif email && name

            @user=User.new
            @user.name=params[:name]
            @user.email=params[:email]

            if @user.save
                render plain:"Success" 
            else
                render plain:"Fail" 
            end
        else
            render plain:"Params error" 
        end

    end




 
end
