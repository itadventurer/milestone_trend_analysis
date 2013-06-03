# -*- coding: utf-8 -*-
# Kümmert sich um Statische Seiten, wie die Hauptseite
class StaticPagesController < ApplicationController
	#Homepage
  def home
    if user_signed_in?
      redirect_to user_root_path
    end
  end
  
  # Rechteverweigerungsseite
  def rights_error
  end
end
