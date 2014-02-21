class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      
      t.references :user
      t.string :name
      t.datetime :due_date
      t.integer :priority, default: nil
      t.boolean :completed, default: false
      t.timestamps
    end
    
    add_index :tasks, :user_id
    add_index :tasks, :due_date
    add_index :tasks, :priority
    add_index :tasks, :completed
  end
end
