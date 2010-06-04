class TimeDisplayHook < Redmine::Hook::ViewListener
  def view_issues_show_details_bottom(context={ })
    context[:controller].send(:render_to_string, {
        :partial => "time_display.erb",
        :locals => context
    })
  end
end