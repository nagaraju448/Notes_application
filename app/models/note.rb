class Note < ApplicationRecord
  belongs_to :created_user, class_name: 'User', foreign_key: :user_id
  has_many :notes_users
  has_many :users, through: :notes_users
end
