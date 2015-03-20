# Tasks about social networks and automatization of messages on the networks

task :send_twitter_poeme => :environment do
  puts "Beginning of sending tweet"
  Poeme.send_tweet
  puts "Tweet has been sent"
end


task :send_twitter_author => :environment do
  puts "Beginning of sending tweet"
  Auteur.send_tweet
  puts "Tweet has been sent"
end