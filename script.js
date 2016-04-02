"use strict";

(function () {

	var state = true;

	$("#carousel-example-generic").hide();

	$( "#logo" ).hover(function(){
	    $(this).filter(':not(:animated)').effect( "shake" );
	});

	$( "#profile_photo" ).hover(function(){
	    $(this).filter(':not(:animated)').animate({ width: "250px" });
	}, function() {
	    $(this).animate({ width: "200px" });
	});

	$( "#aboutme" ).click(function(){
			$(".info").show();
	    $("#carousel-example-generic").hide();
	});

	$( "#portfolio" ).click(function(){
			$(".info").hide();
	    $("#carousel-example-generic").show();
	});

  $( "#oiltrends" ).hover(function() {
    if ( state ) {
      $( ".right_col" ).animate({
        background: url(img/background.jpg),
      }, 1000 );
    } 
    state = !state;
  });

})();