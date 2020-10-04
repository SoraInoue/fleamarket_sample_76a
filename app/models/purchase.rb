class Purchase < ApplicationRecord
  has_many :comments, dependent: :destroy
end
