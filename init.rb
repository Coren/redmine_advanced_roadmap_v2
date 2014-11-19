# encoding: UTF-8

# This plugin should be reloaded in development mode.
if (Rails.env == "development")
  ActiveSupport::Dependencies.autoload_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
end

require "redmine"
require "rubygems"
require "gravatar"

ApplicationHelper.send(:include, AdvancedRoadmap::ApplicationHelperPatch)
CalendarsController.send(:include, AdvancedRoadmap::CalendarsControllerPatch)
Issue.send(:include, AdvancedRoadmap::IssuePatch)
IssuesController.send(:include, AdvancedRoadmap::IssuesControllerPatch)
Project.send(:include, AdvancedRoadmap::ProjectPatch)
ProjectsHelper.send(:include, AdvancedRoadmap::ProjectsHelperPatch)
Query.send(:include, AdvancedRoadmap::QueryPatch)
Redmine::Helpers::Gantt.send(:include, AdvancedRoadmap::RedmineHelpersGanttPatch)
Redmine::I18n.send(:include, AdvancedRoadmap::RedmineI18nPatch)
Version.send(:include, AdvancedRoadmap::VersionPatch)
VersionsController.send(:include, AdvancedRoadmap::VersionsControllerPatch)

require_dependency "advanced_roadmap/view_hooks"

Redmine::Plugin.register :advanced_roadmap do
  name "Advanced roadmap & milestones plugin"
  url "https://redmine.ociotec.com/projects/advanced-roadmap"
  author "Emilio González Montaña"
  author_url "http://ociotec.com"
  description "This is a plugin for Redmine that is used to show more information inside the Roadmap page and implements the milestones featuring."
  version "0.8.0"
  permission :manage_milestones, {:milestones => [:new, :create, :edit, :update, :destroy]}
  requires_redmine :version_or_higher => "2.1.2"

  project_module :issue_tracking do
    permission :view_issue_estimated_hours, {}
  end

  settings :default => {"parallel_effort_custom_field" => "",
                        "solved_issues_to_estimate" => "5",
                        "ratio_good" => "0.8",
                        "color_good" => "green",
                        "ratio_bad" => "1.2",
                        "color_bad" => "orange",
                        "ratio_very_bad" => "1.5",
                        "color_very_bad" => "red"},
           :partial => "settings/advanced_roadmap_settings"
end
