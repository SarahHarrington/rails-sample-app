class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX},
    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    #n This is a build in method from the SecureRandom module in the standard Ruby library
    SecureRandom.urlsafe_base64
  end

  def remember
    #* without self, the assignment would create a local variable
    #* Using self ensure that assignemtn sets the user's remember_token attribute
    self.remember_token = User.new_token
    #n update_attribute allows it to skip validation and only update this attribute
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    #n the remember_token passed in is a variable for the method
    #n it is not the same as the accessor defined initially
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end