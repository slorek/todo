class Task < ActiveRecord::Base
  
  belongs_to :user
  
  validates :name, :user, presence: true
  validates :priority, inclusion: { in: (1..5).to_a }, allow_blank: true
  
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
