$('h1, h2, h3, h4').filter('[id]').each(function () {
    $(this).html('<a href="#'+$(this).attr('id')+'">' + $(this).text() + '</a>');
});