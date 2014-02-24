class Task < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :name, :user
  
  def completed?
    !completed_at.nil?
  end
  
  def self.pending
    where(completed_at: nil)
  end

  def self.completed
    where(arel_table[:completed_at].not_eq(nil))
  end
end
