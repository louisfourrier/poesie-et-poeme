require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://www.poesie-et-poeme.fr'
# For the compression of the sitemap. Disable because several servers do not support gzip
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.create do
  add 'http://www.poesie-et-poeme.fr', :changefreq => 'monthly'
  add '/auteurs', :changefreq => 'monthly'
  add '/poemes', :changefreq => 'monthly'
  
  Auteur.find_each do |auteur|
    add '/auteurs/' + auteur.slug, :lastmod => auteur.updated_at, :priority => 0.5, :changefreq => 'monthly'
  end
  
  Poeme.find_each do |poeme|
    add '/poemes/' + poeme.slug, :lastmod => poeme.updated_at, :priority => 0.5, :changefreq => 'monthly'
  end
  
end