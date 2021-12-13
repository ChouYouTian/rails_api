class ApplicationController < ActionController::API
    include ActionController::Cookies

    def autenticate_spa_user!
        user_id = session[:user_id]
        @user = User.find_by(id: user_id)
        render plain:"pls login" if @user.nil?
    end
end
