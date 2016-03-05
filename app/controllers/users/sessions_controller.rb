class Users::SessionsController < Devise::SessionsController
  
  def create
    # devise use warden
    user  = warden.authenticate!(auth_options)
    token = Tiddle.create_and_return_token(user, request)
    render json:{
                  status: "Success",
                  message: "User signed-in successfully and token created",
                  authentication_token: token
                }
    # example token:
    # QVGMnbXLUqTwtzdnNQCx
    # token length: 20 characters
  end

  def destroy
    # 2 item required from HTTP HEADERS:
    #   1: X-USER-EMAIL "string" // Eg: user@example.com
    #   2: X-USER-TOKEN "string" // Eg: QVGMnbXLUqTwtzdnNQCx

    if current_user
      respond_to do |format|
        # when "Log out" is clicked in HTML, sign out and redirect to root
        # and, no need to delete the token
        format.html { super }
        format.json {
          Tiddle.expire_token(current_user, request)
          render json: { status: "Success", message: "User signed-out successfully" }
        }
      end
    else
      respond_to do |format|
        format.html { super }
        format.json { render json: {status: "Error", message: "User not signed-out"} }
      end
    end

  end

  private

    # this method is invoked before destroy above
    # this method is devise method and we need this method
    # if we remove this method, we'll get 204 No Content
    # and the destroy method above will not be triggered
    # flow: /users/sign_out.json -> this method -> destroy method above
    # learn more: https://github.com/adamniedzielski/tiddle/issues/25
    def verify_signed_out_user
      # just leave it empty
    end

end
