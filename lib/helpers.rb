helpers do
  
  def page_title
    @page_title ||= Haml::Filters::TextileInline.render "Matt Puchlerz -- Designer & Web Developer"
  end
  
end