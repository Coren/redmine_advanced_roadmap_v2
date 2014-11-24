require_dependency "query"

module AdvancedRoadmap
  module QueryPatch
    def self.included(base)
      base.class_eval do
        # Returns the milestones
        # Valid options are :conditions
        def milestones(options = {})
          Milestone.scoped(:conditions => options[:conditions]).find :all,
            :include => :project,
            :conditions => project_statement
        rescue ::ActiveRecord::StatementInvalid => e
          raise StatementInvalid.new(e.message)
        end
      end
    end
  end
end
