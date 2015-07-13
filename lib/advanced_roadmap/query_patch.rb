require_dependency "query"

module AdvancedRoadmap
  module QueryPatch
    def self.included(base)
      base.class_eval do
        # Returns the milestones
        # Valid options are :conditions
        def milestones(options = {})
          # See https://github.com/Coren/redmine_advanced_roadmap_v2/issues/53
          # and https://github.com/nanego/redmine_multiprojects_issue/blob/master/lib/redmine_multiprojects_issue/issue_patch.rb
          if Redmine::Plugin.registered_plugins[:redmine_multiprojects_issue]
            Milestone.where(options[:conditions]).where(project_statement).joins(project: issues).all
          else
            Milestone.where(options[:conditions]).where(project_statement).joins(:project).all
          end
        rescue ::ActiveRecord::StatementInvalid => e
          raise ::ActiveRecord::StatementInvalid.new(e.message)
        end
      end
    end
  end
end
