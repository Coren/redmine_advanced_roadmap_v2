require_dependency "query"

module AdvancedRoadmap
  module QueryPatch
    def self.included(base)
      base.class_eval do
        # Returns the milestones
        # Valid options are :conditions
        def milestones(options = {})
          Milestone.where(options[:conditions]).where(project_statement).joins(:project).all
        rescue ::ActiveRecord::StatementInvalid => e
          raise ::ActiveRecord::StatementInvalid.new(e.message)
        end
      end
    end
  end
end
