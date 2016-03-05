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

  private

  	def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
