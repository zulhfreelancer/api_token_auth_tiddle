class User < ActiveRecord::Base
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable
  
  has_many :authentication_tokens
  has_many :posts
  
end
