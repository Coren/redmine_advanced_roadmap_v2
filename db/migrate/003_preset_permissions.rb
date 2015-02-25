class PresetPermissions < ActiveRecord::Migration
  def self.up
    role = nil
    begin
      role = Role.find(:first, :conditions => "name='Manager'")
    rescue Exception => e
    end
    return true unless role
    role.permissions << :manage_milestones
    role.permissions << :view_issue_estimated_hours
    role.save!
  end

  def self.down
    role = Role.find(:first, :conditions => "name='Manager'")
    return true unless role
    role.permissions.delete :manage_milestones
    role.permissions.delete :view_issue_estimated_hours
    role.save!
  end
end
