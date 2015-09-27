module AdvancedRoadmap
  module JournalPatch
    def self.included(base)
      base.class_eval do
        unloadable
        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method_chain :visible_details, :estimated_time_hidden
        end 
      end
    end

    module InstanceMethods
      def visible_details_with_estimated_time_hidden(user=User.current)
        visible_details = visible_details_without_estimated_time_hidden(user)
        visible_details.select do |detail|
          if detail.prop_key == "estimated_hours"
            User.current.allowed_to?(:view_issue_estimated_hours, project)
          else
            true
          end
        end
      end
    end
  end
end
