# TODO: Figure out why this extra require is needed by Cucumber
require File.join( File.dirname(__FILE__), '..', 'lib', 'haml', 'filters' )

helpers do
  
  def page_title
    @page_title ||= Haml::Filters::TextileInline.render "Matt Puchlerz -- Designer & Web Developer"
  end
  
end