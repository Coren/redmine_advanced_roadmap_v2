class CreateMilestoneVersions < ActiveRecord::Migration
  def self.up
    create_table :milestone_versions, :force => true do |t|
      t.column :milestone_id,     :integer,                           :null => false
      t.column :version_id,       :integer,                           :null => false
      t.column :created_on,       :datetime
    end

    add_index :milestone_versions, [:milestone_id], :name => "fk_milestone_versions_milestone"
    add_index :milestone_versions, [:version_id], :name => "fk_milestone_versions_version"
  end

  def self.down
    drop_table :milestone_versions
  end
end
