require_dependency "application_helper"

module AdvancedRoadmap
  module ApplicationHelperPatch
    def self.included(base)
      base.class_eval do

        def url_for_milestone(milestone_id)
          return(url_for(:controller => :milestones, :action => :show, :id => milestone_id))
        end

        def link_to_milestone(milestone)
          return(link_to(milestone.name, {:controller => :milestones, :action => :show, :id => milestone.id}))
        end

        def color_by_ratio(ratio)
          color = ""
          color = Setting.plugin_advanced_roadmap["color_good"] if ratio <= Setting.plugin_advanced_roadmap["ratio_good"].to_f
          color = Setting.plugin_advanced_roadmap["color_bad"] if ratio >= Setting.plugin_advanced_roadmap["ratio_bad"].to_f
          color = Setting.plugin_advanced_roadmap["color_very_bad"] if ratio >= Setting.plugin_advanced_roadmap["ratio_very_bad"].to_f
          return(color)
        end
  
        def total_graph_tag(versions, totals, options = {})
          small_width = options[:small_width] || 125
          small_height = options[:small_height] || 100
          big_width = options[:big_width] || 500
          big_height = options[:big_height] || 400
          versions_names = versions.collect{|version| version.name}
          versions_percentajes = versions.collect{|version| (((version.spent_hours + version.rest_hours) * 100.0) / (totals[:spent_hours] + totals[:rest_hours]))}
          return(tag("img",
                     :src => url_for(:controller => "milestones",
                                     :action => "total_graph",
                                     :versions => versions_names,
                                     :percentajes => versions_percentajes,
                                     :size => "#{big_width}x#{big_height}"),
                    :title => l(:label_click_to_enlarge_reduce),
                    :style => "cursor: pointer; width: #{small_width}px; height: #{small_height}px;",
                    :id => "total_graph_image",
                    :onclick => "image = document.getElementById('total_graph_image'); if (image.style.width == '#{big_width}px') { image.style.width = '#{small_width}px'; image.style.height = '#{small_height}px'; } else { image.style.width = '#{big_width}px'; image.style.height = '#{big_height}px'; }"))
        end
  
      end
    end
  end
end
