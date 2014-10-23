require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://example.com'
# For the compression of the sitemap. Disable because several servers do not support gzip
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.create do
  add '/verbs', :changefreq => 'monthly'
  
 # Verb.find_each do |verb|
  #  add '/verbs/' + verb.slug, :lastmod => verb.updated_at, :priority => 0.5, :changefreq => 'monthly'
  #end
  
end