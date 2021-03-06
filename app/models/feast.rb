class Feast < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :payments, through: :reservations, source: :feast, class_name: "Feast"
  has_one :chatroom, dependent: :destroy
  belongs_to :user
  validates :title, length: { minimum: 3 }
  validates :description, length: { minimum: 10 }
  validates :meal_type, length: { minimum: 3 }
  validates :guest_limit, length: { minimum: 1 }
  validates :address, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  has_one_attached :photo
  after_create :create_chatroom
  monetize :price_cents
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def host?(user)
    self.user == user
  end

  def create_chatroom
    chatroom = Chatroom.new(feast: self)
    chatroom.save!
  end

end
