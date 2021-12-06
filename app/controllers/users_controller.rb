class UsersController < ApplicationController
    def index
        render plain:"hello" 
    end

    def login
        @user=User.find_by(name:params[:name])

        render plain:"#{@user[:id]} #{@user[:name]}"
    end

    def signup
        @user=User.find_by(name:params[:name])

        if @user
            render plain:"Already exist" 
        else

            @user=User.new
            @user.name=params[:name]

            if @user.save
                render plain:"Success" 
            else
                render plain:"Fail" 
            end
        end
    end

    def name
    end
end
