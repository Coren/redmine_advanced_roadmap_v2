class PresetPermissions < ActiveRecord::Migration
  def self.up
    role = Role.find(:first, :conditions => "name='Manager'")
    role.permissions << :manage_milestones
    role.permissions << :view_issue_estimated_hours
    role.save!
  end

  def self.down
    role = Role.find(:first, :conditions => "name='Manager'")
    role.permissions.delete :manage_milestones
    role.permissions.delete :view_issue_estimated_hours
    role.save!
  end
end
