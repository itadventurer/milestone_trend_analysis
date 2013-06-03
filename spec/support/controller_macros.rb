module ControllerMacros

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @admin = FactoryGirl.create(:admin)
      sign_in @admin
    end
  end

  #loggt einen normalen User ein
  def login_normal
    before(:each) do
      @user = FactoryGirl.create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
    end
  end
  
end
