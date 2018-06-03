class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(*guests)
    puts " hi"
  end
end
