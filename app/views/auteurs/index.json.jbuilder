json.array!(@auteurs) do |auteur|
  json.extract! auteur, :id, :name, :description, :description_source, :birth_date, :death_date, :poemes_count, :century, :first_letter, :slug, :country
  json.url auteur_url(auteur, format: :json)
end
