require_dependency "calendars_controller"

module RedmineAdvancedRoadmap
  module CalendarsControllerPatch
    def self.included(base)
      base.class_eval do

        around_action :add_milestones, :only => [:show]

        def add_milestones
          yield
          lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
          view = ActionView::Base.with_empty_template_cache.new(lookup_context, {}, nil)
          view.class_eval do
            include ApplicationHelper
          end
          milestones = []
          @query.becomes(Query).milestones(:conditions => ["effective_date BETWEEN ? AND ?",
                                            @calendar.startdt,
                                            @calendar.enddt]).each do |milestone|
            milestones << {:name => milestone.name,
                           :url => url_for(:controller => :milestones,
                                           :action => :show,
                                           :id => milestone.id, :only_path => true),
                           :day => milestone.effective_date.day}
          end
          renderer = ActionView::Renderer.new(lookup_context)
          response.body += renderer.render(view, { file: Rails.root.join('plugins', 'redmine_advanced_roadmap_v2', 'app', 'views', 'hooks', 'calendars', '_milestones.html.erb'), :locals => {:milestones => milestones} })
        end

      end
    end
  end
end
