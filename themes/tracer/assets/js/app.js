console.log("Welcome to the OpenTracing docs!");

// hacky, but this preserves position on sidebar nav through page loads
// also makes the current page bold
document.addEventListener("DOMContentLoaded", function(){
    let currentUrl = "//" + document.location.host + document.location.pathname
    if (document.querySelectorAll(".submenu").length > 0) {
        var currentPage = document.querySelectorAll("a[href='" + currentUrl + "']")
        currentPage[0].style.fontWeight = 'bold';
        currentPage[0].parentElement.parentElement.previousElementSibling.previousElementSibling.checked = false
    }
  });