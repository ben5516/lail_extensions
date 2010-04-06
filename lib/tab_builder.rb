class TabBuilder
  attr_reader :tabs
  
  def initialize(template, url, verb, current_mode, options)
    @template, @url, @verb, @current_mode = template, url, verb, current_mode
    @tabs = []
  end
  
  def make(text, mode=nil)
    if (mode==@current_mode)
      tabs << "<li class=\"current\"><div class=\"left\"></div><div class=\"middle\">#{text}</div><div class=\"right\"></div></li>"
    else
      url = mode ? "#{@url}?#{@verb}=#{URI.escape mode}" : @url
      tabs << "<li><a href=\"#{url}#tabs\">#{text}</a></li>"
    end
  end
end
  
class ActionView::Base
  
  def tab_control_for(verb, options={}, &block)
    concat "<div class=\"tab-control\">"
    tabs_for(verb, options, &block)
    concat "<div class=\"tab-body\">"
    concat render :partial => instance_variable_get("@#{verb}")
    concat "</div>"
    concat "</div>"
  end
  
  def tabs_for(verb, options={}, &block)
    unless url=options[:url]
      url = @controller.request.request_uri
      url = url.split("?").first if url.index("?")
    end
    current_mode = params[verb] || options[:default]
    separator = options[:separator] || "" #"&nbsp;&nbsp;|&nbsp;&nbsp;"
      
    concat "<ul id=\"tabs\" class=\"tabs\">"
      t = TabBuilder.new(self, url, verb, current_mode, options)
      yield t
      concat t.tabs.join(separator)
    concat "</ul>"
  end
  
end