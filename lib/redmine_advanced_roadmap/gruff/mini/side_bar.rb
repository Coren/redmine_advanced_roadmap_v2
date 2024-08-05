##
#
# Makes a small pie graph suitable for display at 200px or even smaller.
#
module RedmineAdvancedRoadmap
  module Gruff
    module Mini

      class SideBar < RedmineAdvancedRoadmap::Gruff::SideBar

        include RedmineAdvancedRoadmap::Gruff::Mini::Legend
        
        def initialize_ivars
          super
          @hide_legend = true
          @hide_title = true
          @hide_line_numbers = true

          @marker_font_size = 50.0
          @legend_font_size = 50.0
        end
        
        def draw
          expand_canvas_for_vertical_legend
          
          super
          
          draw_vertical_legend
          
          @d.draw(@base_image)
        end
        
      end
      
    end
  end
end
