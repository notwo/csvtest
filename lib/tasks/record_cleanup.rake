namespace :record_cleanup do
  desc '毎日0時に、昨日以前のレコードを全削除する'
  task estimates: :environment do
    Estimate.where("created_at <= '#{1.days.ago}'").destroy_all
  end
end
