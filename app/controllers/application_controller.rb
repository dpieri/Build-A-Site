class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :shitty_browser
  
  def shitty_browser
    flash[:notice] = "Please use a different browser (Chrome or Safari)" unless users_browser
  end
  
  def users_browser
  return  false unless request.env['HTTP_USER_AGENT']
  user_agent =  request.env['HTTP_USER_AGENT'].downcase 
  @users_browser ||= begin
    if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
          false
      elsif user_agent.index('gecko/')
          false
      elsif user_agent.index('opera')
          false
      elsif user_agent.index('konqueror')
          true
      elsif user_agent.index('ipod')
          true
      elsif user_agent.index('ipad')
          true
      elsif user_agent.index('iphone')
          true
      elsif user_agent.index('chrome/')
          true
      elsif user_agent.index('applewebkit/')
          true
      elsif user_agent.index('googlebot/')
          true
      elsif user_agent.index('msnbot')
          true
      elsif user_agent.index('yahoo! slurp')
          true
      #Everything thinks it's mozilla, so this goes last
      elsif user_agent.index('mozilla/')
          false
      else
          true
      end
      end

      return @users_browser
  end
end
