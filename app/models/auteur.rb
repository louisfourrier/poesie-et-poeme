# == Schema Information
#
# Table name: auteurs
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  description_source :text
#  birth_date         :date
#  death_date         :date
#  poemes_count       :integer
#  century            :integer
#  first_letter       :string(255)
#  slug               :string(255)
#  country            :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  research_name      :text
#  html_content       :text
#  crawl_url          :text
#  image_url          :text
#  date_string        :string(255)
#

class Auteur < ActiveRecord::Base
  require 'net/http'
  require 'uri'
  
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  
  has_many :poemes, dependent: :destroy
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  after_create :update_research_name
  after_create :update_first_letter
  before_validation :set_slug_to_nil # For the friendly id gem
  
  # Convert the content in Nokogiri Nodes
  def html_content_to_html
    html = Nokogiri::HTML(self.html_content)
  end
  
  def birth_date_f
    self.date_string.split('-').first
  end
  
  def death_date_f
    self.date_string.split('-').last
  end
  
  def recueil_set
    self.poemes.pluck(:recueil).uniq.delete_if{|a| a.empty?}
  end
  
  def extract_country
    begin
    html = self.html_content_to_html
    country = html.css('#resultats_auteur li').first['class']
    self.update(:country => country.to_s)
    rescue
    end
  end
  
  def extract_date_string
    begin
      html = self.html_content_to_html
      date = html.css('//*[@id="resultats_auteur"]/li/text()').text.gsub('/n', '').strip
      date = date || ""
      self.update(:date_string => date)
    rescue
      self.update(:date_string => "")
    end
  end
  
  def extract_small_description
    begin
    html = self.wikipedia_html
    description = html.css('p').first.text
    self.update(:description => description)
    rescue
    end
  end
  
  def clean_description
    description = self.description
    description = self.gsub('Rediriger vers :', '')
    description = self.gsub('error', '')
    self.update(:description => description)
  end
  
  def self.execute_class_method(method_name)
    self.find_each do |a|
      a.send(method_name)
    end
  end
  
  def extract_poemes_links
    begin
    html = self.html_content_to_html
    poemes_links = []
    page_links = html.css('a')
    auteur_url = URI(self.crawl_url.to_s)
    page_links.each do |link|
      link = link['href']
      url = auteur_url.merge(link).to_s
      poemes_links << url
    end
    return poemes_links
    rescue
    end
  end
  
  ## WIKIPEDIA
  
  def wikipedia_name
    string = self.name.strip
    string = string.tr('ÉÈË', 'éèë')
    string = string.titleize
    string = string.gsub(' ', '_')
    string = string.gsub('De', 'de')
    return string
  end
  
  def wikipedia_url
    return "http://fr.wikipedia.org/wiki/" + self.wikipedia_name
  end
  
  def wikipedia_request
    puts self.id.to_s
    uri = URI('http://fr.wikipedia.org/w/api.php')
    params = { :action => 'parse', :page => self.wikipedia_name, :format => "json" }
    uri.query = URI.encode_www_form(params)
    
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      json = JSON.parse(res.body)
      begin
        self.update(:description_source => json["parse"]["text"]["*"])
      rescue
        self.update(:description_source => "error")
      end
    else
      self.update(:description_source => "nosuccess")
    end
  end
  
  def wikipedia_html
     html = Nokogiri::HTML(self.description_source)
  end
  
  def wikipedia_extract_image
    html = Nokogiri::HTML(self.description_source)
    image = html.css('.images img').first
    if !image.nil?
      image_url = 'http:' + image['src'].to_s
      if self.image_url.nil?
        self.update(:image_url => image_url)
      end
    else
      image2 = html.css('.thumbinner img').first
      if !image2.nil?
      image_url = 'http:' + image2['src'].to_s
        if self.image_url.nil?
          self.update(:image_url => image_url)
        end
      end
    end
  end
  
  def google_image_search
    begin
    uri = URI('https://ajax.googleapis.com/ajax/services/search/images')
    search_query = self.name + " poete"
    puts search_query
    params = { :v => '1.0', :q => search_query }
    uri.query = URI.encode_www_form(params)
    
    res = Net::HTTP.get_response(uri)
    json = JSON.parse(res.body)
    puts json.to_s
    image_first = json["responseData"]["results"].first
    if !image_first.nil?
      image_url = image_first["unescapedUrl"]
      puts image_url
      if self.image_url.nil?
          self.update(:image_url => image_url)
        end
    end
    rescue
      "ERROR"
    end
  end
  
  def self.update_image_url
    self.find_each do |auteur|
      auteur.wikipedia_extract_image
      if auteur.image_url.nil?
        auteur.google_image_search
      end
    end
  end
  
  def wikipedia_sanitize_description
    begin
    html = self.wikipedia_html
    html.css('#toc, #bandeau-portail').remove
    html.css('.mw-editsection, .plainlinks, .homonymie, .navbox, .navbox_group, .infobox_v3').remove
    self.update(:description_source => html.to_html)
    rescue
    end
  end
  ## END
  
  def set_slug_to_nil
    if name_changed?
      self.slug = nil
    end
  end
  
  def update_research_name
    res_name = I18n.transliterate(self.name.to_s.strip)
    self.update(:research_name => res_name)
  end

  def update_first_letter
    first_letter = self.name.first
    self.update(:first_letter => first_letter)
  end
  
end
