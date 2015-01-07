require_dependency "version"

module AdvancedRoadmap
  module VersionPatch
    def self.included(base)
      base.class_eval do
  
        has_many :milestone_versions, :dependent => :destroy
        has_many :milestones, :through => :milestone_versions
  
        def completed_percent_with_advanced_info
          calculate_advance_info unless @total_ratio
          @total_ratio
        end
        alias_method_chain :completed_percent, :advanced_info
  
        def closed_percent_with_advanced_info
          calculate_advance_info unless @total_finished_ratio
          @total_finished_ratio
        end
        alias_method_chain :closed_percent, :advanced_info
  
        def rest_hours
          calculate_advance_info unless @total_pending
          @total_pending
        end
  
        def estimated_speed
          calculate_advance_info unless @progress_factor
          @progress_factor
        end
  
        def closed_spent_hours
          if !@closed_spent_hours
            @closed_spent_hours = 0.0
            fixed_issues.each do |issue|
              if issue.closed?
                @closed_spent_hours += issue.spent_hours
              end
            end
          end
          @closed_spent_hours
        end
  
        def calculate_advance_info
          total_estimated = 0.0
          total_spent = 0.0
          @total_pending = 0.0
          @total_speed_pending = 0.0
          total_partial_pending = 0.0
          total_full_pending = 0.0
          @total_finished_ratio = 0.0
          @total_ratio = 0.0
          solved_issues = 0
          total_solved_estimated = 0.0
          total_solved_spent = 0.0
          if fixed_issues.size > 0
            fixed_issues.each do |issue|
              if issue.children.empty?
                if issue.estimated_hours && issue.done_ratio
                  ratio = issue.spent_hours / ((issue.estimated_hours * issue.done_ratio) / 100.0)
                end
                total_estimated += issue.estimated_hours ? issue.estimated_hours : 0.0
                total_spent += issue.spent_hours ? issue.spent_hours : 0.0
                if issue.spent_hours and issue.spent_hours > 0.0
                  total_partial_pending += issue.rest_hours ? issue.rest_hours : 0.0
                else
                  total_full_pending += issue.rest_hours ? issue.rest_hours : 0.0
                end
                if issue.closed?
                  solved_issues += 1
                  total_solved_estimated += issue.estimated_hours ? issue.estimated_hours : 0.0
                  total_solved_spent += issue.spent_hours ? issue.spent_hours : 0.0
                end
                if issue.spent_hours && issue.rest_hours
                  issue_time = (issue.spent_hours + issue.rest_hours) * issue.done_ratio
                  if issue.closed?
                    @total_finished_ratio += issue_time
                  end
                  @total_ratio += issue_time
                end
              end
            end
            if solved_issues < Setting.plugin_advanced_roadmap_v2["solved_issues_to_estimate"].to_i or total_solved_estimated == 0.0
              @progress_factor = nil
            else
              @progress_factor = total_solved_spent / total_solved_estimated
            end
            if total_spent + total_partial_pending + total_full_pending > 0.0
              @total_pending = total_partial_pending + total_full_pending
              @total_speed_pending = total_partial_pending + (total_full_pending * (@progress_factor.nil? ? 1.0 : @progress_factor))
              @total_finished_ratio /= (total_spent + @total_pending)
              @total_ratio /= (total_spent + @total_pending)
            else
              @total_finished_ratio = 0.0
              @total_ratio = 0.0
            end
          end
        end
  
        def sorted_fixed_issues(options = {})
          issues = []
          conditions = {:parent_id => options[:parent]}
          conditions[:tracker_id] = options[:trackers] if options[:trackers]
          fixed_issues.visible.find(:all,
                                    :conditions => conditions,
                                    :include => [:status, :tracker, :priority],
                                    :order => "#{Tracker.table_name}.position, #{Issue.table_name}.subject").each do |issue|
            issues << issue
            issues += sorted_fixed_issues(options.merge(:parent => issue))
          end
          issues
        end
  
        def parallel_factor
          factor = 1.0
          if !(custom_field = CustomField.find_by_id(Setting.plugin_advanced_roadmap_v2["parallel_effort_custom_field"].to_i)).nil? and
             custom_field.field_format == "float"
            if !(custom_value = CustomValue.find(:first, :conditions => {:customized_type => "Version", :customized_id => id, :custom_field_id => custom_field.id})).nil?
              factor = custom_value.value.to_f
            else
              factor = custom_field.default_value.to_f
            end
            factor = 1.0 if factor <= 0.0
          end
          factor
        end
  
        def parallel_rest_hours
          rest_hours / parallel_factor
        end
  
        def speed_rest_hours
          calculate_advance_info unless @total_speed_pending
          @total_speed_pending
        end
  
        def parallel_speed_rest_hours
          speed_rest_hours / parallel_factor
        end
  
        def self.sort_versions(versions)
          versions.sort!{|a, b|
            if !a.effective_date.nil? and !b.effective_date.nil?
              a.effective_date <=> b.effective_date
            elsif a.effective_date.nil? and !b.effective_date.nil?
              1
            elsif !a.effective_date.nil? and b.effective_date.nil?
              -1
            elsif a.rest_hours != b.rest_hours
              a.rest_hours <=> b.rest_hours
            else
              a.name.downcase <=> b.name.downcase
            end
          }
        end
        
        def self.calculate_totals(versions)
          totals = {}
          totals[:estimated_hours] = 0.0
          totals[:spent_hours] = 0.0
          totals[:rest_hours] = 0.0
          totals[:speed_rest_hours] = 0.0
          totals[:parallel_rest_hours] = 0.0
          totals[:parallel_speed_rest_hours] = 0.0
          totals[:completed_percent] = 0.0
          totals[:closed_percent] = 0.0
          versions.each do |version|
            totals[:estimated_hours] += version.estimated_hours
            totals[:spent_hours] += version.spent_hours
            totals[:rest_hours] += version.rest_hours
            totals[:speed_rest_hours] += version.speed_rest_hours
            totals[:parallel_rest_hours] += version.parallel_rest_hours
            totals[:parallel_speed_rest_hours] += version.parallel_speed_rest_hours
            totals[:completed_percent] += version.spent_hours
            totals[:closed_percent] += version.closed_spent_hours
          end
          totals[:total] = totals[:spent_hours] + totals[:rest_hours]
          if totals[:total] > 0.0
            totals[:completed_percent] = (totals[:completed_percent] * 100.0) / totals[:total]
            totals[:closed_percent] = (totals[:closed_percent] * 100.0) / totals[:total]
          end
          totals
        end
        
      end
    end
  end
end
