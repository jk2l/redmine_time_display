require_dependency 'issue'

module IssuePatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable
    end

  end

  module ClassMethods

  end

  module InstanceMethods
    def helper_spent_hours
      @helper_spent_hours = TimeEntry.sum :hours, :conditions => "user_id != '#{assigned_to_id}' AND issue_id = '#{id}'"
    end

    def assigned_spent_hours
      @assigned_spent_hours = TimeEntry.sum :hours, :conditions => "user_id = '#{assigned_to_id}' AND issue_id = '#{id}'"
    end

    def self_spent_hours
      @self_spent_hours ||= time_entries.sum(:hours) || 0.00
    end

    def subtask_spent_hours
      all_time = self_and_descendants.sum("#{TimeEntry.table_name}.hours", :include => :time_entries).to_f 
      @subtask_spent_hours ||= all_time - time_entries.sum(:hours) || 0.00
    end

    def estimated_spent
      if estimated_hours == nil or estimated_hours == 0
        @esimtated_spent = "NA"
      else
        @estimated_spent = (assigned_spent_hours/estimated_hours*100).to_i
      end
    end

  end
end
