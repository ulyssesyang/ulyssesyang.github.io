"use strict";

(function () {

	var gamestart = function(){

		//initial game data
		var color=['red','purple','lightgreen','gray','orange','darkred','blue','yellow','brown','lightblue'];
		var cards=$('.card');
		var winPoints=7;
		var currentPoints=0;
		var totalSteps=12;
		var currentSteps=0;
		var images=[];
		var difficulty='medium';
		var matchimages=[];
		var matchcards=[];
		var matchdonecards=[];
		var audio_assigncard = new Audio("audio/assigncard.wav");
		var audio_autoflip = new Audio("audio/autoflip.wav");
		var audio_click = new Audio("audio/click.wav");
		var audio_dogbark = new Audio("audio/dogbark.wav");
		var audio_flipcards = new Audio("audio/flipcards.wav");
		var audio_mouseover = new Audio("audio/mouseover.wav");
		var audio_losegame = new Audio("audio/sadwhisle.wav");
		var audio_wingame = new Audio("audio/yatta.mp3");

		//update Game Difficulty Rule
		var updateGameRule = function(difficulty, totalSteps, winPoints){
			$('.gamerule').html('Game difficulty is <strong>'+difficulty+'</strong><br>You can match dogs <strong>'
													+totalSteps+ '</strong> times! <br>'+'If you match more than <strong>'
													+winPoints+ '</strong> dogs, then you win!');
		}
		//update Game Status
		var updateGameStatus = function(currentPoints,currentSteps){
			$('.gamestatus').html('<br>You have matched <strong>'+currentPoints+'</strong> dogs!<br><br>'+
													'You have <strong>'+(totalSteps- currentSteps)+ '</strong> times to match dogs!');
		}

		//flip Card front to show card image in 1s
		var flipCardfront = function(){
			$('.card.flipped .cardback').css({transform:'rotateY(0deg)'},1000);
			$('.card.flipped .cardfront').css({transform:'rotateY(-180deg)'},1000);
			audio_flipcards.play();
		}

		//flip Card back to show card color in 0.6s
		var flipCardback = function(){
			$('.card.flipped .cardback').css({transform:'rotateY(-180deg)'},600);
			$('.card.flipped .cardfront').css({transform:'rotateY(0deg)'},600);
			audio_autoflip.play();
		}

		//default difficulty level: medium
		updateGameRule(difficulty,totalSteps,winPoints);

		//difficulty level menu
		var levelmenu = $(".levelmenu");
	  levelmenu.hover(function(event){
	  		$('.levelmenu ul').children('a').addClass("hover");
	  		$('.ChooseDifficulty').show();
	  		audio_mouseover.play();
	  		event.stopPropagation();
	  }, function(){
	  		if($('.levelmenu ul').hasClass('hover')!==true){
	  			$('.levelmenu ul').children('a').removeClass("hover");
	    		$('.ChooseDifficulty').delay(1000).hide(0);
	  		} else {
	  			$('.levelmenu ul').children('a').removeClass("hover");
	    		$('.ChooseDifficulty').delay(1000).hide(0);
	  		}
	  		event.stopPropagation();
	  });

	  //choose difficulty level
	  $('#easy').on('click',function(){
	   	winPoints=6;
			totalSteps=15;
			difficulty='easy';
			updateGameRule(difficulty,totalSteps,winPoints);
			audio_click.play();
	 	});
	  $('#medium').on('click',function(){
	   	winPoints=7;
			totalSteps=12;
			difficulty='medium';
			updateGameRule(difficulty,totalSteps,winPoints);
			audio_click.play();
	 	});
	 	$('#hard').on('click',function(){
	   	winPoints=8;
			totalSteps=10;
			difficulty='hard';
			updateGameRule(difficulty,totalSteps,winPoints);
			audio_click.play();
	 	});

		//initial start card and hide cards
		$('.start').css('background-color',color[Math.floor(Math.random()*color.length)]);
		$('.card').children().hide();

		//reset Card
		var resetCard = function(){

			//reset card property
			$('.cardfront').css({'transform':''},{'background-image':''},{'background-color':''});
			$('.cardback').css({'transform':''},{'background-image':''},{'background-color':''});

			//reset image
			images=['img/1.png','img/2.png','img/3.png','img/4.png',
								'img/5.png','img/6.png','img/7.png','img/8.png',
								'img/1.png','img/2.png','img/3.png','img/4.png',
								'img/5.png','img/6.png','img/7.png','img/8.png'];

			//assign card color and images
			for (var i = 0; i < cards.length; i++) {
				//assign random color
				var randomcolor=color[Math.floor(Math.random()*color.length)];
				$(cards[i]).children().first().css('background-color',randomcolor);

				//assign random image
				var randomindeximages=Math.floor(Math.random()*images.length);
				var getimage=images[randomindeximages];
				$(cards[i]).children().last().css('background-image','url('+getimage+')');
				//remove assigned images
				images.splice(randomindeximages,1);
			};

			//reset match card, points and steps
			resetmatchCard();
			currentPoints=0;
			currentSteps=0;
			matchdonecards=[];
		}

		//reset matchcards
		var resetmatchCard = function(){
			matchimages=[];
			matchcards=[];
		}

		//auto flip back different cards
		var autoflipCard =  function(){
			//flip card back to show front color and remove 'flipped' marks from cards
			if(matchimages[0]!==matchimages[1]) {
				flipCardback();
				$('.card.flipped').removeClass('flipped');
			//if both of matching cards have the same image then no need to flip back and just remove 'flipped' marks from cards
			} else if(matchimages[0]===matchimages[1]) {
				$('.card.flipped').removeClass('flipped');
				currentPoints=currentPoints+1;
				audio_dogbark.play();
				for (var i = 0; i < matchcards.length; i++) {
					matchdonecards.push(matchcards[i]);
				};
			} 
			//reset matchcards
			resetmatchCard();
			//update game status
			currentSteps=currentSteps+1;
			updateGameStatus(currentPoints,currentSteps);
		}

		//check if still have steps while math the enough number cards
		var checkWin = function() {
			if ((currentSteps<=totalSteps)&&(currentPoints>=winPoints)){
				audio_wingame.play();
				//remove cards and update game status and show the start card again
				$('.card').hide('slow');
				$('.gamestatus').html('<br>You win the game! <br><br> Want to play again?')
				$('#start').show("slow");
				$('#levelmenu').show("slow");
			}
		}

		//check if outrun the steps
		var checkLose = function() {
			if ((currentSteps>=totalSteps)&&(currentPoints<winPoints)){
				audio_losegame.play();
				//remove cards and update game status and show the start card again
				$('.card').hide('slow');
				$('.gamestatus').html('<br>You lose the game! <br><br> Try again!')
				$('#start').show("slow");
				$('#levelmenu').show("slow");
			}
		}

		//check the clicked card is already matched
		var checkMatchdonecards = function() {
			if(matchdonecards.length>=2) {
				for (var i = 0; i < matchdonecards.length; i++) {
					if (matchcards[matchcards.length-1]===matchdonecards[i]) {
						return true
					} else{
						return false
					};
				};
			} else {
				return false
			};
		}
		
		//click to start card to reset cards
		$('#start').on('click',function(){
			audio_assigncard.play();
			$('.gamestatus').html('<br><strong>Match puppies now!</strong>');
			//hide start card during the game
			$('#start').hide("slow");
			$('#levelmenu').hide("slow");
			//show cards
			$('.card').show('slow');
			$('.card').children().show('slow');
			resetCard();
		});

		//click cards to trigger matching functions
		$('.card').on('click',function(){

			var temp=$(this).attr('id');
			//check if this card matched yet
			if(!matchdonecards.includes(temp)) {
				//only trigger two match cards
				if( matchcards.length<2) {
					//get the triggered card id
					matchcards.push($(this).attr('id'));
					//mark the matching card as 'flipped card' to show image
					$(this).addClass('flipped');
					flipCardfront();
					//get the triggered card image
					matchimages.push($(this).children().last().css('background-image'));
					//check if the second match card is different
					if((matchcards.length>=2)&&(matchcards[1]!==matchcards[0])){
						//set timer for auto flip cards
						setTimeout(function(){ 
							autoflipCard();
							checkWin();
							checkLose();
						}, 800);
						//check if the second match card is the same
					}	else if((matchcards.length>=2)&&(matchcards[1]===matchcards[0])){
						matchcards.pop();
						matchimages.pop();
					}
				}//only trigger two matching cards
			} 
		});
	}

	$(document).ready(function(){
		gamestart();
	})
	
})();