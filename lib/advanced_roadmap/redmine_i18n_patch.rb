require_dependency "redmine/i18n"

module AdvancedRoadmap
  module RedmineI18nPatch
    def self.included(base)
      base.class_eval do
        def l_days(days)
          days = days.to_f
          l((days == 1.0 ? :label_f_day : :label_f_day_plural), :value => ("%.2f" % days.to_f))
        end
  
        def l_weeks(weeks)
          weeks = weeks.to_f
          l((weeks == 1.0 ? :label_f_week : :label_f_week_plural), :value => ("%.2f" % weeks.to_f))
        end
      end
    end
  end
end
