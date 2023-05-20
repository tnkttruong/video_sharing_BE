class Video < ApplicationRecord
  belongs_to :user
  scope :newest, -> { order created_at: :desc }
end
