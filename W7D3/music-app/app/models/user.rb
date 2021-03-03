# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'securerandom'
require 'bcrypt'

class User < ApplicationRecord
  after_initialize :ensure_session_token

  attr_reader :password
  
  validates :email, :session_token, {presence: true, uniqueness: true}
  validates :password_digest, {presence: true}
  validates :password, {length: {minimum: 6, allow_nil: true}}
  validate :ensure_email_format

  def self.find_by_session_token(token)
    User.find_by(session_token: token)
  end

  def is_password?(password)
     BCrypt::Password.new(self.password_digest) == password
  end

  def self.find_with_password(params)
    user = User.find_by(email: params[:email])

    if user
      user.is_password?(params[:password]) ? user : false
    else
      nil
    end
  end

  def password=(pwd)
    @password = pwd
    self.password_digest = BCrypt::Password.create(pwd)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end

  private
  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def ensure_email_format
    unless URI::MailTo::EMAIL_REGEXP.match?(self.email)
      self.errors[:base] << "Email must comply with the correct format"
    end
  end
end
