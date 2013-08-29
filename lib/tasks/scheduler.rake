desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Updating feed..."
  Feed.globalFeedUpdate
  puts "done."
end