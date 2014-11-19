module AdvancedRoadmap
  class ViewHooks < Redmine::Hook::ViewListener

    render_on(:view_projects_show_sidebar_bottom, :partial => "hooks/milestones")
    render_on(:view_issues_sidebar_planning_bottom, :partial => "hooks/milestones")
    render_on(:view_issues_show_details_bottom, :partial => "hooks/issues/show")
    render_on(:view_layouts_base_html_head, :partial => "hooks/stylesheet")

  end
end
