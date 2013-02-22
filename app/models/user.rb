class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.pw_hash == BCrypt::Engine.hash_secret(password, user.pw_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.pw_salt = BCrypt::Engine.generate_salt
      self.pw_hash = BCrypt::Engine.hash_secret(password, pw_salt)
    end
  end
end
