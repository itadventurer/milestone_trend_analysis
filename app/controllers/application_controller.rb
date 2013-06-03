# -*- coding: iso-8859-1 -*-
# Basiscontroller, kümmert sich um ein paar Vorbereitungen
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale # get locale directly from the user model

  add_crumb I18n.t('misc.home'),'/'

  # Bei nicht ausreichenden Rechten wird auf die Startseite verwiesen
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url
  end

  # Setzt die Sprache
  def set_locale
    I18n.locale = user_signed_in? ? current_user.language.to_sym : I18n.default_locale
  end

end
