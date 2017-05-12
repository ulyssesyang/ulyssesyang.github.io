"use strict";

(function() {

    $(".carousel").hide();

    $("#logo").hover(function() {
        $(this).filter(':not(:animated)').effect("shake");
    });

    // $( "#profile_photo" ).hover(function(){
    //     $(this).filter(':not(:animated)').animate({ width: "250px" });
    // }, function() {
    //     $(this).animate({ width: "200px" });
    // });

    $("#aboutme").click(function() {
        $(".info").show();
        $(".carousel").hide();
    });

    $(".portfolio").click(function() {
        $(".info").hide();
        $(".carousel").show();
    });

})();