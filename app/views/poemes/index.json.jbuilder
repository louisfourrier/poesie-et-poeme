json.array!(@poemes) do |poeme|
  json.extract! poeme, :id, :title, :content, :recueil, :slug, :written_date, :auteur_id
  json.url poeme_url(poeme, format: :json)
end
