namespace :task do
  task :parse_all => :environment do

    Report.parse_all
  end
end
