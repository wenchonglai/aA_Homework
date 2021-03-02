# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username       :string           not null
#  password_digest :string
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "SecureRandom"
require "BCrypt"

class User < ApplicationRecord
  attr_reader :password
  after_initialize :ensure_session_token
  validates :email, {presence: true}
  validates :username, :session_token, {presence: true, uniqueness: true}
  validates :password, {length: {minimum: 6}, allow_nil: true}

  has_many :cats,
    foreign_key: :user_id,
    class_name: :Cat

  def password=(pwd)
    self.password_digest = BCrypt::Password.create(pwd)
    @password = pwd
  end

  def is_password?(pwd)
    BCrypt::Password.new(self.password_digest) == pwd
  end

  def self.find_by_credentials(username, pwd)
    user = User.find_by(username: username)

    if user && user.is_password?(pwd)
      user
    else
      nil
    end
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end
end
