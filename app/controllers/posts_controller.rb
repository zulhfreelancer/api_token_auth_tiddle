class PostsController < ApplicationController
  
  # 2 item required from HTTP HEADERS to get all posts:
  # 	1: X-USER-EMAIL "string" // Eg: user@example.com
  # 	2: X-USER-TOKEN "string" // Eg: QVGMnbXLUqTwtzdnNQCx
  before_action :authenticate_user!

  def index
    render json: Post.all
  end

end
