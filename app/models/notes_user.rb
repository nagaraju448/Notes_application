class NotesUser < ApplicationRecord
  belongs_to :user
  belongs_to :note
end
