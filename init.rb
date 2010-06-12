require 'redmine'

require_dependency 'issue_patch'
require_dependency 'time_display_hook'

require 'dispatcher'
Dispatcher.to_prepare do
  Issue.send(:include, IssuePatch)
end

Redmine::Plugin.register :redmine_time_display do
  name 'Redmine Time Display plugin'
  author 'Jacky Leung'
  description 'Create a seperate area in issue to display current assigned user spent time'
  version '0.1.1'
end
