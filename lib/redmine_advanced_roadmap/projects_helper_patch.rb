require_dependency "projects_helper"

module RedmineAdvancedRoadmap
  module ProjectsHelperPatch
    def self.included(base)
      base.class_eval do
        alias_method :project_settings_tabs_without_more_tabs, :project_settings_tabs
        def project_settings_tabs_with_more_tabs
          tabs = project_settings_tabs_without_more_tabs
          options = {:name => 'versions', :action => :manage_versions, :partial => 'projects/settings/versions', :label => :label_version_plural}
          index = tabs.index(options)
          unless index # Needed for Redmine v3.4.x
            options[:url] = {:tab => 'versions', :version_status => params[:version_status], :version_name => params[:version_name]}
            index = tabs.index(options)
          end
          #index = tabs.index({:name => 'versions', :action => :manage_versions, :partial => 'projects/settings/versions', :label => :label_version_plural})
          if index
            tabs.insert(index, {:name => "milestones", :action => :manage_milestones, :partial => "projects/settings/milestones", :label => :label_milestone_plural})
            tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}     
          end
          return(tabs)
        end
        alias_method :project_settings_tabs, :project_settings_tabs_with_more_tabs
      end
    end
  end
end
