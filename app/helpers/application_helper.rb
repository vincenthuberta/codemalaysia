module ApplicationHelper
  
  
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
  
  class String
  
    def shuffle
      self.split('').shuffle.join
    end
  end
end
