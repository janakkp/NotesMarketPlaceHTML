/*============================================
                    Navigation
==============================================*/
/* Show & Hide White Navigation */
$(function () {
    // show/hide nav on page load
    showHideNav();

    $(window).scroll(function () {

        // show/hide nav on window's scroll
        showHideNav();
    });
    function showHideNav() {
        if ($(window).scrollTop() > 50) {

            // Show white nav
            $("nav").addClass("white-nav-top");

            // Show dark logo
            document.getElementById("image1").src = "../img/logo.png";
            document.getElementById("image2").src = "../img/logo.png";

            // Show back to top button
            $("#back-to-top").fadeIn();
        } else {

            // Hide white nav
            $("nav").removeClass("white-nav-top");




            // Show logo
            document.getElementById("image1").src = "../img/top-logo.png";
            document.getElementById("image2").src = "../img/top-logo.png";
            // Hide back to top button
            $("#back-to-top").fadeOut();
        }
    }
});

// Smooth Scrolling
$(function () {
    $("a.smooth-scroll").click(function (event) {
        event.preventDefault();

        // get section id like about, ##services, #work, #team and etc.
        var section_id = $(this).attr("href");

        $("html, body").animate({
            scrollTop: $(section_id).offset().top - 64
        }, 1250, "easeInOutExpo");
    });
});

/*============================================
             Mobile Menu
==============================================*/
$(function () {
    // Show mobile nav
    $("#mobile-nav-open-btn").click(function () {
        $("#mobile-nav").css("width", "100%");
    });

    // Hide mobile nav
    $("#mobile-nav-close-btn, #mobile-nav a").click(function () {
        $("#mobile-nav").css("width", "0%");
    });

});