class WatchParty < ApplicationRecord
  validates :date, :time, :duration, :movie_title, presence: true
  validates :duration, numericality: { only_integer: true }

  belongs_to :user
  has_many :guests, dependent: :destroy
  has_many :invitees, through: :guests

  def valid_party(date)
    date > Time.zone.now
  end

  def valid_party_time(time)
    time > Time.zone.now.strftime('%H:%M')
  end
end
