require_dependency "versions_controller"

module RedmineAdvancedRoadmap
  module VersionsControllerPatch
    def self.included(base)
      base.class_eval do
  
        def index_with_plugin
          index_without_plugin
          @totals = Version.calculate_totals(@versions)
          Version.sort_versions(@versions)

          @issues_by_version.each do |versions|
	    versions.last.delete_if { |issue | issue.closed? }
          end if params[:only_open]

        end
        alias_method :index_without_plugin, :index
        alias_method :index, :index_with_plugin
  
        def show
          @issues = @version.sorted_fixed_issues
        end
      
      end
    end
  end
end
