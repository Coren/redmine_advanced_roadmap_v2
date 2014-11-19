require_dependency "query"

module AdvancedRoadmap
  module QueryPatch
    def self.included(base)
      base.class_eval do
  
        # Returns the milestones
        # Valid options are :conditions
        def milestones(options = {})
          Milestone.find(:all,
                         :include => :project,
                         :conditions => Query.merge_conditions(project_statement, options[:conditions]))
        rescue ::ActiveRecord::StatementInvalid => e
          raise StatementInvalid.new(e.message)
        end
  
      end
    end
  end
end
