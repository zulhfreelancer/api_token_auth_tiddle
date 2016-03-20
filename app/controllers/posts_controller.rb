class PostsController < ApplicationController
  
  # 2 item required from HTTP HEADERS to get all posts:
  # 	1: X-USER-EMAIL "string" // Eg: user@example.com
  # 	2: X-USER-TOKEN "string" // Eg: QVGMnbXLUqTwtzdnNQCx
  before_action :authenticate_user!
  before_action :set_user

  before_action :set_post, only: [:destroy]

  def index
    render json: Post.all.order(updated_at: :desc)
  end

  def create
  	@post = @user.posts.new(post_params)
  	if @post.save
  		render json: @post
  	else
  		render json: {status: "Error", message: "Failed to save post"}
  	end
  end

  def destroy
    @post.destroy

    if @post.destroyed?
      render json: {status: "Success", message: "Post destroyed"}
    else
      render json: {status: "Error", message: "Failed to destroy the post"}
    end
  end

  private

  	def set_user
  		@user = current_user
  	end

    def set_post
      @post = Post.find(params[:id])
    end

  	def post_params
      params.require(:post).permit(:body)
    end

end
