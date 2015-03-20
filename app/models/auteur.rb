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
  
   # Filter the query for controller
  def self.filter(attributes)
    attributes.inject(self) do |scope, (key, value)|
      #return scope.scoped if value.blank?
      if value.blank?
        scope.all
      else
      case key.to_sym
      when :country
        value = value.to_s
        scope.where("auteurs.country ILIKE ?", "%#{value}%")
      when :century
        scope.by_century(value.to_i)
      when :order # order=field-(ASC|DESC)
        attribute, order = value.split("-") 
        scope.order("#{self.table_name}.#{attribute} #{order}")
      else # unknown key (do nothing or raise error, as you prefer to)
        scope.all
      end 
    end
    end
  end
  
  def birth_date_f
    begin
      self.date_string.split('-').first.gsub(/[\(\)]/, '')
    rescue
     self.date_string.split('-').first
    end
  end
  
  def death_date_f
    begin
      self.date_string.split('-').last.gsub(/[\(\)]/, '')
    rescue
      self.date_string.split('-').last
    end
  end
  
  def birth_date_integer
    string = self.birth_date_f.gsub(/\D/, '')
    integer = string.to_i
    if integer > 1000
      return integer
    else
      return nil
    end
  end
  
  def death_date_integer
    string = self.death_date_f.gsub(/\D/, '')
    integer = string.to_i
    if integer > 1000
      return integer
    else
      return nil
    end
  end
  
  
  # Method that send a tweet about a random verb in the Database
  def self.send_tweet
    auteur = self.order("RANDOM()").first
    message = self.possible_messages
    message = message + " " + auteur.name
    url = "http://www.poesie-et-poeme.fr" + Rails.application.routes.url_helpers.auteur_path(auteur)
    tags = auteur.name.to_s + "," + self.possible_tags
    SocialPresence.send_message(message, url, tags)
  end
  
   def self.possible_tags
    tab = ["poesie", "poeme", "litterature", "poesiefrancaise", "culture"]
    return tab.shuffle.first(2).join(',')
  end
  
  # All the different messages for the tweet
  def self.possible_messages
    tab = []
    tab << "Poésie francaise : "
    tab << "Connaissez vous l'auteur :"
    tab << "Toute la poésie francaise : "
    tab << "Toute la poésie de "
    tab = tab.shuffle
    return tab.first  
  end
  
  def get_century_birth(number)
    integer = number
    if integer
      return (integer / 100) + 1
    else
      return nil
    end
  end
  
  def update_century_float
    birth_century = self.get_century_birth(self.birth_date_integer)
    death_century = self.get_century_birth(self.death_date_integer)
    if birth_century && death_century
      century = (birth_century + death_century) / 2.0
      self.update(:century_float => century)
    end
  end
  
  def self.by_century(century)
    century = century.to_f
    minus_century = century - 0.5
    more_century = century + 0.5
    return self.where('auteurs.century_float = ? OR auteurs.century_float = ? OR auteurs.century_float = ?', century, minus_century, more_century)
  end
  
  def recueil_set
    self.poemes.pluck(:recueil).uniq.delete_if{|a| a.empty?}
  end
  
  def country_image
    code = self.country
    image = code + "_drapeau.png"
  end
  
  def country_alt_code
    return self.country.to_s + " drapeau"
  end
  
  def self.all_countries
    return [["FR", "France"], ["CH", "Suisse"], ["CA", "Canada"], ["HT", "Haiti"], ["PL", "Pologne"], ["BE", "Belgique"], ["EC", "Ecosse"], ["US", "Etats-Unis"], ["RU", "Royaume uni"], ["AT", "Autriche"], ["AG", "Allemagne"]] 
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
    begin
    description = self.description
    description = description.gsub('Rediriger vers :', '')
    description = description.gsub('error', '')
    description = description.gsub(/\[\d\]/, '')
    self.update(:description => description)
   rescue
   end
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
