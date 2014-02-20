class Task < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :name, :user
  
  def self.pending
    where(completed: false)
  end
end
