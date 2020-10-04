class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # def update_without_current_password(user_params, *options)
  #   binding.pry
  #   user_params.delete(:current_password)

  #   if user_params[:password].blank? && user_params[:password_confirmation].blank?
  #     user_params.delete(:password)
  #     user_params.delete(:password_confirmation)
  #   end

  #   result = update_attributes(user_params, *options)
  #   clean_up_passwords
  #   result
  # end
  has_many :items, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :destination, inverse_of: :user, dependent: :destroy
  accepts_nested_attributes_for :destination
  

  validates_associated :destination

  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

  validates :password, presence: true, length: { minimum: 7}
  validates :family_name, presence: true,
  format: { with: /[^-｡-ﾟ]+/}
  validates :first_name, presence: true,
  format: { with: /[^-｡-ﾟ]+/}
  validates :family_name_kana, presence: true,
  format: { with: /[^-｡-ﾟ]+/}
  validates :first_name_kana, presence: true,
  format: { with: /[^-｡-ﾟ]+/}
  validates :birthday, presence: true


end
