window.addEvent('domready', function() { 
             
  [ 'strong', '#document_footer p' ].each( function(selector) {
    $$(selector).each( function(el) {
      var text = el.get('text');
      text = text.replace('–', '-');
      text = text.replace('—', '--');
      el.set('text', text);          
    });
    Cufon.replace(selector);
  });
    
});
