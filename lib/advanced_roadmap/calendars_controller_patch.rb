require_dependency "calendars_controller"

module AdvancedRoadmap
  module CalendarsControllerPatch
    def self.included(base)
      base.class_eval do

        around_filter :add_milestones, :only => [:show]

        def add_milestones
          yield
          view = ActionView::Base.new(File.join(File.dirname(__FILE__), "..", "..", "app", "views"))
          view.class_eval do
            include ApplicationHelper
          end
          milestones = []
          @query.milestones(:conditions => ["effective_date BETWEEN ? AND ?",
                                            @calendar.startdt,
                                            @calendar.enddt]).each do |milestone|
            milestones << {:name => milestone.name,
                           :url => url_for(:controller => :milestones,
                                           :action => :show,
                                           :id => milestone.id, :only_path => true),
                           :day => milestone.effective_date.day}
          end
          response.body += view.render(:partial => "hooks/calendars/milestones",
                                       :locals => {:milestones => milestones})
        end

      end
    end
  end
end
