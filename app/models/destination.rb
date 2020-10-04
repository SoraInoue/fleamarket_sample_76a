class Destination < ApplicationRecord
  belongs_to :user, inverse_of: :destination

  validates :destination_family_name, presence: true,
  format: { with: /[^-｡-ﾟ]+/}
  validates :destination_first_name, presence: true,
  format: { with: /[^-｡-ﾟ]+/}
  validates :destination_family_name_kana, presence: true,
  format: { with: /[^-｡-ﾟ]+/}
  validates :destination_first_name_kana, presence: true,
  format: { with: /[^-｡-ﾟ]+/}
  validates :postal_code, presence: true
  validates :prefecture_id, presence: true
  validates :city, presence: true
  validates :street_block, presence: true
  validates :nickname, presence: true

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

end