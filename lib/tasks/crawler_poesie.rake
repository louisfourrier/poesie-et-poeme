
# Hellocoton crawler.Mode
task :poetes_crawler => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'uri'

  HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}", "read_timeout" => "30"}
  # Base Url
  BASE_URL = "http://poesie.webnet.fr/lesgrandsclassiques/poemes/"
  
  # Generate all the page to parse
  array_explore = ("a".."z").to_a 
  links = []
  sub_string = "liste_auteurs_"
  array_explore.each do |letter|
    letter_link = BASE_URL.to_s + sub_string + letter + ".html"
    links << letter_link  
  end
  
  puts links.to_s
  # Array of all the auteur page links
  auteurs_links = []
  
  # Crawl the auteurs pages to get all the auteurs links
  links.each do |href|
    puts "Crawling of " + href.to_s
    page = Nokogiri::HTML(open(href))
    page_links = page.css('#listing_auteurs li a')
    page_links.each do |a|
      lien = a['href']
      lien = BASE_URL.to_s + lien
      auteurs_links << lien
    end
  end
  
  auteurs_links.each do |href|
    puts "Crawling of " + href.to_s
    page = Nokogiri::HTML(open(href))
    url = href.to_s
    name = page.css('#resultats_auteur li strong').text
    html = page.css('#left_side > div:nth-child(3)')
    html_content = html.to_html.encode!('UTF-8', :undef => :replace, :invalid => :replace, :replace => "") 
    Auteur.create(:name => name, :html_content => html_content, :crawl_url => url)
  end

  
  
  
end



# Hellocoton crawler.Mode
task :poemes_crawler => :environment do
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'uri'

  HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}", "read_timeout" => "30"}
  # Base Url
  BASE_URL = "http://poesie.webnet.fr/lesgrandsclassiques/poemes/"
  
  Auteur.find_each do |auteur|
    puts auteur.name.to_s
    poemes_links = auteur.extract_poemes_links
    poemes_links.each do |href|
      puts "Crawling of " + href.to_s
      page = Nokogiri::HTML(open(href))
      url = href.to_s
      title = page.css('#left_side > div:nth-child(3) > h1').text
      content = page.css('#left_side > div:nth-child(3) > p').to_html.encode!('UTF-8', :undef => :replace, :invalid => :replace, :replace => "")
      recueil = page.css('#les_grands_classiques > h4').text
      html = page.css('#left_side > div:nth-child(3)')
      html_content = html.to_html.encode!('UTF-8', :undef => :replace, :invalid => :replace, :replace => "") 
      poeme = Poeme.new(:title => title, :content => content, :crawl_url => url, :html_content => html_content, :recueil => recueil)
      auteur.poemes << poeme
    end
    
    
  end
  
end



