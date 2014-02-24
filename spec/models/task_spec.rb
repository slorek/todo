require 'spec_helper'

describe Task do
    
  let(:task) { Task.new }
  
  describe "#completed?" do
    context "when the Task is incomplete" do
      it "returns false" do
        task.completed_at = nil
        expect(task.completed?).to eq false
      end
    end
    
    context "when the Task is complete" do
      it "returns true" do
        task.completed_at = Time.now
        expect(task.completed?).to eq true
      end
    end
  end
end
