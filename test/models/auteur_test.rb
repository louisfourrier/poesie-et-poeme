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

require 'test_helper'

class AuteurTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
