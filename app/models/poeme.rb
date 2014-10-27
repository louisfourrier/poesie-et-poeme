# == Schema Information
#
# Table name: poemes
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  content       :text
#  recueil       :text
#  slug          :string(255)
#  written_date  :date
#  auteur_id     :integer
#  created_at    :datetime
#  updated_at    :datetime
#  research_name :text
#  first_letter  :string(255)
#  html_content  :text
#  crawl_url     :text
#

class Poeme < ActiveRecord::Base
  belongs_to :auteur
  counter_culture :auteur
  
  validates :title, presence: true
  #validates :title, uniqueness: { case_sensitive: false }
  
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  after_create :update_research_name
  after_create :update_first_letter
  before_validation :set_slug_to_nil # For the friendly id gem
  
  def slug_candidates
    auteur = self.auteur.name
    tab = [:title, [:title, auteur] ]
    return tab
  end
  
  def initialize_slug
    self.slug = nil
    self.save
  end
  
  def sanitize_recueil
    recueil = self.recueil.gsub('Recueil :', '').strip
    self.update(:recueil => recueil)
  end
  
  def self.execute_class_method(method_name)
    self.find_each do |a|
      a.send(method_name)
    end
  end
  
  def set_slug_to_nil
    if title_changed?
      self.slug = nil
    end
  end
  
  def update_research_name
    res_name = I18n.transliterate(self.title.to_s.strip)
    self.update(:research_name => res_name)
  end

  def update_first_letter
    first_letter = self.title.first
    self.update(:first_letter => first_letter)
  end
end
