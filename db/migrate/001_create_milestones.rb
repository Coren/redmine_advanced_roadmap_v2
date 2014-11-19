class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones, :force => true do |t|
      t.column :name,             :string,                            :null => false
      t.column :description,      :string,      :default => ""
      t.column :effective_date,   :date
      t.column :user_id,          :integer,                           :null => false
      t.column :project_id,       :integer,                           :null => false
      t.column :created_on,       :datetime
      t.column :updated_on,       :datetime
    end

    add_index :milestones, [:user_id], :name => "fk_milestones_user"
    add_index :milestones, [:project_id], :name => "fk_milestones_project"
  end

  def self.down
    drop_table :milestones
  end
end
