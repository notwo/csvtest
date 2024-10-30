class RecordCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    request_numbers = args.first

    dir = 'C:\Users\07k11\Desktop\work\csvtest'
    filename = "#{dir}\requests_#{Time.now.in_time_zone('Tokyo').strftime('%Y%m%d%H%M%S')}.csv"

    # csv出力
    csv_nils = Array.new(47)
    CSV.open(filename, 'w') do |row|
      request_numbers.each do |request_number|
        row << csv_nils.concat(request_number)
      end
    end
  end
end
