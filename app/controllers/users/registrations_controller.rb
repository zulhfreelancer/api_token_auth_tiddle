class Users::RegistrationsController < Devise::RegistrationsController

  def create
  	# check if there already user using the email
  	email = params[:user][:email]
  	if User.find_by_email(email)
  		# stop this create block straight away and show error
  		return render json: {status: "Error", message: "Email already taken"}
  	end

  	# if can't found user using the email, proceed by saving the user
    user = User.new(user_params)
    if user.save
    	token = Tiddle.create_and_return_token(user, request)
    	render json:{
	                  status: "Success",
	                  message: "User registered successfully and token created",
	                  authentication_token: token
	                }
    else
    	render json: {status: "Error", message: "User not registered"}
    end
  end

  def update

    respond_to do |format|
      format.html {super}
      format.json {
        # also required X-USER-EMAIL and X-USER-TOKEN inside the headers
        email = request.headers["X-USER-EMAIL"]
        user  = User.find_by_email(email)
        if params[:user][:password] == params[:user][:password_confirmation]
          if user.update(password: params[:user][:password])
            destroy_all_token(user)
            render json: {status: "Success", message: "Password changed"}
          else
            render json: {status: "Error", message: "Password not changed"}
          end
        else
          render json: {status: "Error", message: "Password not matched"}
        end
      }
    end

  end

  private

  	def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    # every time after user change password, destroy all user's token(s)
    # why not make this as after_update callback in User model?
    # because `Tiddle.expire_token(...) method` inside sessions_controller
    # also trigger this method if we make this method as after_update callback
    # when user sign out (destroy session) in HTML,
    # we don't want to delete his/her token. we only want to delete his/her token
    # after he/she change his/her password
    def destroy_all_token(user)
      user.authentication_tokens.destroy_all
      # in JS app, we must sign out the user after they change their password
      # and show a notice saying their `password has been changed successfully`
      # after they log in again, they will get a new token
    end

end
