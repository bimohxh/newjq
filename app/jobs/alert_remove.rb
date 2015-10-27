class AlertRemoveJob < ActiveJob::Base
  queue_as :default

  def perform ids
    #Alert.destroy_all(:id=>ids)
    Alert.where(:id=>ids).update_all(:status=> 'READED')
  end

end
