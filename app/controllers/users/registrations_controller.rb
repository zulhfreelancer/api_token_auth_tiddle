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
        email = params[:user][:email]
        user  = User.find_by_email(email)
        if params[:user][:password] == params[:user][:password_confirmation]
          if user.update(password: params[:user][:password])
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

end
