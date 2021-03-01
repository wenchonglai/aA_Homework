require 'bcrypt'
require 'securerandom'

class User < ApplicationRecord
  attr_reader :password
  
  before_validation :ensure_session_token
  validates :username, :session_token, {presence: true}
  validates :password_digest, {presence: {message: "Password can't be blank"}}
  validates :password, {length: {minimum: 6}, allow_nil: true}

  def password=(pwd)
    @password = pwd
    self.password_digest = BCrypt::Password.create(pwd)
  end

  def self.find_by_credentials(username, pwd)
    user = User.find_by(username: username)
    return user if user && BCrypt::Password.new(user.password_digest) == pwd
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
