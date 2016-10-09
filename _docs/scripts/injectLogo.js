function injectLogo() {
  var imageUrl =  !!~location.href.indexOf('/pages/')  ? '../' : '';
  $('.book-summary')
    .prepend('<a class="opentracing-logo" href="http://opentracing.io"><img src="' + imageUrl + 'images/logo.png"></a>')
};

injectLogo();
gitbook.events.bind('page.change', injectLogo);
