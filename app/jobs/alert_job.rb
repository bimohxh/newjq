class AlertJob < ActiveJob::Base
  queue_as :default

  def perform item
    Alert.create(item)
  end

end
