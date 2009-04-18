helpers do
  
  # Converts the text to HTML using Textile
  def textilize(text)
    if text == '' or text.nil? #text.blank?
      ""
    else
      textilized = RedCloth.new(text, [ :hard_breaks ])
      textilized.hard_breaks = true if textilized.respond_to?(:hard_breaks=)
      textilized.to_html
    end
  end
  alias_method :t, :textilize
  
  # Converts the text to HTML using Textile, but does not surround 
  # the text in <p> tags like usual.
  def textilize_without_paragraph(text)
    textiled = textilize(text)
    if textiled[0..2] == "<p>" then textiled = textiled[3..-1] end
    if textiled[-4..-1] == "</p>" then textiled = textiled[0..-5] end
    return textiled
  end
  alias_method :textilize_inline, :textilize_without_paragraph
  alias_method :ti, :textilize_without_paragraph
  
  def page_title
    @page_title ||= ti "Matt Puchlerz -- Designer & Web Developer"
  end
  
end