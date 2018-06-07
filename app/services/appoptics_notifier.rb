require "appoptics/metrics"

class AppopticsNotifier

APPOPTICS_KEY = Rails.application.secrets[:appoptics_key]

  def initialize
    AppOptics::Metrics.authenticate APPOPTICS_KEY
  end

  def notify_metric(metric_name, value)
    AppOptics::Metrics.submit metric_name.to_sym => { value: value, tags: { host: 'localhost' } }
    Rails.logger.info "#{ metric_name } Metric Logged to Appoptics with #{ value }."
  end

  def increment_event(event_name)
    notify_metric(event_name, 1)
  end
end
