class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable
  
  has_many :authentication_tokens, dependent: :destroy
  has_many :posts, dependent: :destroy
  
  after_update :destroy_all_token
  
  # every time after user change password, destroy all user's token(s)
  def destroy_all_token
  	self.authentication_tokens.destroy_all
  	# in JS app, we must sign out the user after they change their password
  	# and show a notice saying their `password has been changed successfully`
  	# after they log in again, they will get a new token
  end
end
