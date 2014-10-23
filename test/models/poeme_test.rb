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

require 'test_helper'

class PoemeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
