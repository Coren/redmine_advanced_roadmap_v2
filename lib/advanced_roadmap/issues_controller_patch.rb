require_dependency "issues_controller"

module AdvancedRoadmap
  module IssuesControllerPatch
    def self.included(base)
      base.class_eval do
  
      protected
  
        def render(options = nil, extra_options = {}, &block)
          if ((@action_name == "show") and
              (!(User.current.allowed_to?(:view_issue_estimated_hours, @project))) and
              (!(@journals.nil?)))
            @journals.each do |journal|
              journal.details.delete_if{|detail| detail.prop_key == "estimated_hours"}
            end
            @journals.delete_if{|journal| journal.details.empty?}
          end
          super(options, extra_options)
        end
  
      end
    end
  end
end
