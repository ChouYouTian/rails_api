class UsersController < ApplicationController
    before_action :autenticate_spa_user! ,only: [:delete]
    


    def login
        user=User.find_by(email:params[:email])

        if user && user.authenticate(params[:password])
            session[:user_id] = { value: user.id, expires: Time.now + 1.hours}

            render json:{
                :code=>0,
                :user_id=>user[:id],
                :user_name=>user[:name]
            }
        else
            render json:{
                :code=>1,
                :msg=>"not found ,pls check user name or email"   
            }
        end
    end

    def logout
        session.delete(:user_id)
        render json:{
            :code=>0,
            :msg=>"Logout"   
        }
    end

# {
#     "name":"username",
#     "email":"useremail",
#     "password":"userpassword",
#     "confirmPassword":"confirmpassword"
# }
    def signup
        user=User.find_by(email: params[:email])

        if user
            code=1
            msg="User already exist"
        elsif params[:password] !=params[:confirmPassword]
            code=1
            msg="The password is inconsistent with the confirmation password"
        elsif params[:email] && params[:name]
            user=User.new(name: params[:name],email: params[:email],password: params[:password])

            if user.save
                code=0
                msg="success" 
            else
                code=>1
                msg="Fail,pls try again" 
            end
        else
            code=1
            msg="Params error"
        end

        render json:{
            :code=>code,
            :msg=>msg
        }
    end

    def delete

        if @user.delete_user!
            render json:{
                :code=>0,
                :msg=>"Success"
            }
        else
            render json:{
                :code=>1,
                :msg=>"fail"
            }
        end
    end




 
end
