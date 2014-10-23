class LayoutGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :layout_name, :type => :string, :default => "application"
   
  def add_bootstrap
    copy_file "bootstrap.css", "vendor/assets/stylesheets/bootstrap.css"
    copy_file "application.css", "app/assets/stylesheets/application.css"
    
    copy_file "bootstrap.js", "vendor/assets/javascripts/bootstrap.js"
    copy_file "application.js", "app/assets/javascripts/application.js"
  end
  
  def add_default_stylesheet
    copy_file "_colors.css.scss", "app/assets/stylesheets/_colors.css.scss"
    template "homes.css.scss.erb", "app/assets/stylesheets/homes.css.scss.erb"
  end
  
  def add_fonts
    directory 'fonts', 'app/assets/fonts'
  end
  
  def add_images
    directory 'images', 'app/assets/images'
  end
  
  def change_gemfile
    copy_file "Gemfile", "Gemfile"
  end
  
  def change_database_yml
    template "database.yml.erb", "config/database.yml"
  end
  
  def change_unicorn
    copy_file "Procfile", "Procfile"
    copy_file "config.ru", "config.ru"
    copy_file "unicorn.rb", "config/unicorn.rb"
  end
  
  def change_production_config
    copy_file "production.rb", "config/environments/production.rb"
  end
  
  def put_sitemap_config_file
    copy_file "sitemap.rb", "config/sitemap.rb"
  end
  
  def change_application_controller_for_translation
    copy_file "application_controller.rb", "app/controllers/application_controller.rb"
  end
  
  def layout_files
    template "application.html.erb", "app/views/layouts/application.html.erb"
    template "_navbar.html.erb", "app/views/layouts/_navbar.html.erb"
    template "_meta_common.html.erb", "app/views/layouts/_meta_common.html.erb"
    template "_footer.html.erb", "app/views/layouts/_footer.html.erb"
    template "_end_scripts.html.erb", "app/views/layouts/_end_scripts.html.erb"
  end
  
  def generate_first_page
    generate "controller", "home main"
    copy_file "routes.rb", "config/routes.rb"
  end
  
  # Change in order to take into account translation
  def change_application_config
    application do
      "config.i18n.default_locale = :fr"
      "config.i18n.available_locales = [:fr, :en]"
      "config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]"
    end
  end
  
  # Add the default language yml files
  def add_language_yml
    directory 'locales', 'config/locales'
  end
  
  # Add the common commands text files
  def add_various
    copy_file "common_commands", "common_commands"
  end
  
  # Create database and the compiled assets
  def rake_commands
    rake 'db:create'
    rake 'db:migrate'
  end
  
  
end
