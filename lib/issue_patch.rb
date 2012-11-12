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
      @helper_spent_hours = TimeEntry.sum :hours, :conditions => "user_id != #{assigned_to_id.to_i} AND issue_id = '#{id}'"
    end

    def assigned_spent_hours
      @assigned_spent_hours = TimeEntry.sum :hours, :conditions => "user_id = #{assigned_to_id.to_i} AND issue_id = '#{id}'"
    end

    def self_spent_hours
      @self_spent_hours ||= time_entries.sum(:hours) || 0.00
    end

    def subtask_spent_hours
      time = 0.00
      i.descendants.each do |i|
        time = time + i.time_entries.sum(:hours)
      end
      @subtask_spent_hours = time.to_f
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
