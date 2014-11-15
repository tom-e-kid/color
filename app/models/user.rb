class User < ActiveRecord::Base
  before_save { email.downcase! }

  NAME_REGEX = /\A[\w\.]+\z/i
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 16, minimum: 3 }, format: { with: NAME_REGEX }
  validates :email, presence: true, format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false } 

  has_secure_password
  validates :password, length: { minimum: 6 }
end
