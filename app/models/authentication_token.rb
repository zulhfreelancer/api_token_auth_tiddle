class AuthenticationToken < ActiveRecord::Base
  belongs_to :user
end
