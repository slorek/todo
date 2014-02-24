class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      
      t.references :user
      t.string :name
      t.datetime :due_date
      t.integer :priority, default: nil
      t.datetime :completed_at
      t.timestamps
    end
    
    add_index :tasks, :user_id
    add_index :tasks, :due_date
    add_index :tasks, :priority
    add_index :tasks, :completed_at
  end
end
