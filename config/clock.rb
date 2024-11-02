require 'clockwork'

module Clockwork
  every(1.day, 'estimates_cleanup', at: '00:00') do
    Estimate.where("created_at <= '#{1.days.ago}'").destroy_all
  end
end
