"use strict";

(function() {

    $(".carousel .slide").hide();

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
        $(".carousel .slide").hide();
    });

    $("#portfolio").click(function() {
        $(".info").hide();
        $(".carousel .slide").show();
    });

    $("#oiltrends").click(function() {
        $(".info").hide();
        $(".carousel .slide").show();
    });

    $("#daytrippr").click(function() {
        $(".info").hide();
        $(".carousel .slide").show();
    });

    $("#forum").click(function() {
        $(".info").hide();
        $(".carousel .slide").show();
    });

    $("#memory").click(function() {
        $(".info").hide();
        $(".carousel .slide").show();
    });

})();