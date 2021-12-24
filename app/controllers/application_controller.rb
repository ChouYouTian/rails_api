class ApplicationController < ActionController::API
    include ActionController::Cookies

    def autenticate_spa_user!
        user_id = session[:user_id][:value]
        expires=session[:user_id][:expires]
        
        @user = User.find_by(id: user_id)
        if @user.nil? ||expires<Time.now
            session.delete(:user_id)
            # render plain:"pls login" 
            render json:{
                :code=>8,
                :msg=>"pls login"   
            }
        end


    end
end
