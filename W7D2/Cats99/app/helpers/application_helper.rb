module ApplicationHelper
  def auth_token
    
    html = "<input name='authenticity Token' type='hidden' value='#{form_authenticity_token}'>"
    html.html_safe
  end
end
