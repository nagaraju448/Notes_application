class User < ApplicationRecord
  has_many :notes_users
  has_many :notes, :through => :notes_users
  has_many :own_notes, class_name: 'Note', foreign_key: :user_id
  enum role: {admin: 0, user: 1}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end
end
