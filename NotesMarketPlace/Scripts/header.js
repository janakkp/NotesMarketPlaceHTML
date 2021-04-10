/*============================================
             Mobile Menu
==============================================*/
$(function(){
    // Show mobile nav
    $("#mobile-nav-open-btn").click(function(){
        $("#mobile-nav").css("width","100%");
    });

    // Hide mobile nav
    $("#mobile-nav-close-btn, #mobile-nav a").click(function(){
        $("#mobile-nav").css("width","0%");
    });
    
});
