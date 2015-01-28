## Class that permits to send automatic message to twitter accounts
## I do not know if it needs several application configuration

class TwitterSender
  require 'twitter'

  # Method accessible from the outside
  def self.send_tweet(message, url, tags)
    tweet = self.convert_message_in_tweet(message, url, tags)
    self.sender(tweet)
  end
  
  #TODO Implement a counting method to check the size of the tweet
  #TODO Implement a callback to see if the tweet has been correctly updated on send_tweet
  
  #TODO Implement function to follow tweets containing certain tags
  #TODO Implement functions to follow the people emeting the tweets
  
  # Test Method
  def self.test
    tweet = self.convert_message_in_tweet("Bonjour le test", "http://les-conjugaisons.com", ["test", "louis"])
    self.sender(tweet)
  end
  
  private
  
  # Initialize a client twitter object
  def self.client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "whyZ2M0L8cUfMXPAAupULuxY0"
      config.consumer_secret     = "7fUGaNAnr8lNNVHe2FbyDHzf1e7TqR5iaqJSJi7bxiktDdpIs4"
      config.access_token        = "2988339203-FLHJnOPmzHczJG0CDpPGR1Q89VIMIp0f4BUxcbx"
      config.access_token_secret = "ehH4fA9Yzp2QjJxFeKiVJl35RFNJ0sCJNxOQKYG0tY69H"
    end
    return client
  end
  
  # Methods that send the tweet
  def self.sender(tweet)
    client = self.client
    client.update(tweet)
  end
  
  # Convert the message in the twitter form
  def self.convert_message_in_tweet(message, url, tags)
    message= message.to_s
    url = url.to_s
    tags_array = []
    tags.each do |t|
      s = "#" + t.to_s
      tags_array << s
    end
    
    tags_string = tags_array.join(' ')
    tweet = message + " " + url + " " + tags_string
    return tweet
  end
  
 

end