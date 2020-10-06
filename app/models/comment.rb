class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :item
  belongs_to :purchase, optional: true
end
