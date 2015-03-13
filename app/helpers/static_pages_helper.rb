module StaticPagesHelper
  include AuthHelper
  
  def o365_login_url
    login_url = get_login_url
  end
end
