ActiveSupport::Notifications.subscribe "perform.active_job" do |name, started, finished, unique_id, data|
  notifier = AppopticsNotifier.new
  metric_name = data[:job].class
  notifier.increment_event(metric_name.to_s + '_Count')
  notifier.notify_metric(metric_name.to_s + '_Execution_time', finished - started)
  Rails.logger.info "Excecution time = #{ finished - started }"
end
