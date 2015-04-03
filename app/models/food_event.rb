class FoodEvent < ActiveRecord::Base

  include ActionView::Helpers::DateHelper

  before_save :fix_times

  validates_uniqueness_of :title

  validates :title, presence: true
  validates :date, presence: true
  validates :address, presence: true
  # validates :time, presence: true
  # validates :allday, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  def fix_times
    if self.start_time.length <= 5
      self.start_time = "#{self.date} #{self.start_time}"
      self.end_time = "#{self.date} #{self.end_time}"
    end
  end

  def time_from_now
    if self.start_time > Time.now
      distance_of_time_in_words(Time.now, self.start_time)
    else
      "-#{time_ago_in_words(self.start_time)}"
    end
  end



end
