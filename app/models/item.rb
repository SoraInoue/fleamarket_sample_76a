class Item < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many_attached :images
  belongs_to :genre
  has_many :reviews, dependent: :destroy
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, optional: true, class_name: "User"

  validate :images_presence
  validates :name, :introduction, :genre_id, :condition_id, :delivery_fee_id, :pref_id, :day_id, :seller_id, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 300, less_than_or_equal_to: 9999999 }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :pref, presence: true
  belongs_to_active_hash :condition, presence: true
  belongs_to_active_hash :delivery_fee, presence: true
  belongs_to_active_hash :day, presence: true

  def images_presence
    if images.attached?
      # inputに保持されているimagesがあるかを確認
      if images.length > 10
        errors.add(:image, '10枚まで投稿できます')
      end
    else
      errors.add(:image, '画像がありません')
    end
  end

  def self.search(search)
    if search
      return Item.all unless search
      Item.where('name LIKE(?)',"%#{search}%")
    end
  end
end
