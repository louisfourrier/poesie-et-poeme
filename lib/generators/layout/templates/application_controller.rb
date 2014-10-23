class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale
  
  private
  
  # Set the language
  def set_locale
    if params[:locale].present?
      I18n.locale = params[:locale]
    elsif !extract_locale_from_accept_language_header.nil?
      I18n.locale = extract_locale_from_accept_language_header
    else
      # Default locale is set in the application.rb file (set to french)
      I18n.locale = I18n.default_locale
    end
  end
  
  # Get language from browser
  def extract_locale_from_accept_language_header
    begin
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    rescue
      return nil
    end
  end
  
  # For all the link_to
  def default_url_options(options={})
  { locale: I18n.locale }
  end
  
end
