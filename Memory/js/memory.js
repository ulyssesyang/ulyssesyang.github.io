"use strict";

(function () {

	var gamestart = function(){

		//initial game data
		var color=['red','purple','lightgreen','gray','orange','darkred','blue','yellow','brown','lightblue'];
		var cards=$('.card');
		var matchCard=0;
		var winPoints=7;
		var currentPoints=0;
		var totalSteps=12;
		var currentSteps=0;
		var images=[];
		var difficulty='medium';
		var originalCards=$('.cards');
		var tempimages=[];
		var tempcards=[];

		//update Game Difficulty Rule
		var updateGameRule = function(difficulty, totalSteps, winPoints){
			$('.gamerule').html('Game difficulty is <strong>'+difficulty+'</strong><br>You can match dogs <strong>'
													+totalSteps+ '</strong> times! <br>'+'If you match more than <strong>'
													+winPoints+ '</strong> dogs, then you win!');
		}
		//update Game Status
		var updateGameStatus = function(currentPoints,totalSteps){
			$('.gamestatus').html('<br>You have matched <strong>'+currentPoints+'</strong> dogs!<br><br>'+
													'You have <strong>'+(totalSteps- currentSteps)+ '</strong> times to match dogs!');
		}

		//flip Card front to show card back image in 1s
		var flipCardfront = function(){
			$('.card.flipped .cardback').css({transform:'rotateY(0deg)'},1000);
			$('.card.flipped .cardfront').css({transform:'rotateY(-180deg)'},1000);
		}

		//flip Card back to show card front image in 0.6s
		var flipCardback = function(){
			$('.card.flipped .cardback').css({transform:'rotateY(-180deg)'},600);
			$('.card.flipped .cardfront').css({transform:'rotateY(0deg)'},600);
		}

		//default difficulty level: medium
		updateGameRule(difficulty,totalSteps,winPoints);

		//difficulty level menu
		var levelmenu = $(".levelmenu");
	  levelmenu.hover(function(){
	  		$('.levelmenu ul').children('a').addClass("hover")
	  		$('.ChooseDifficulty').show();
	  }, function(){
	  		if($('.levelmenu ul a').hasClass('hover')!==true){
	  			$('.levelmenu ul').children('a').removeClass("hover");
	    		$('.ChooseDifficulty').delay(1000).hide(0);
	  		} else {
	  			$('.levelmenu ul').removeClass("hover");
	    		$('.ChooseDifficulty').delay(1000).hide(0);
	  		}
	  });

	  //choose difficulty level
	  $('#easy').on('click',function(){
	   	winPoints=6;
			totalSteps=15;
			difficulty='easy';
			updateGameRule(difficulty,totalSteps,winPoints);
	 	});
	  $('#medium').on('click',function(){
	   	winPoints=7;
			totalSteps=12;
			difficulty='medium';
			updateGameRule(difficulty,totalSteps,winPoints);
	 	});
	 	$('#hard').on('click',function(){
	   	winPoints=8;
			totalSteps=10;
			difficulty='hard';
			updateGameRule(difficulty,totalSteps,winPoints);
	 	});

		//initial start card and hide cards
		$('.start').css('background-color',color[Math.floor(Math.random()*color.length)]);
		$('.card').children().hide();

		//reset Card
		var resetCard = function(){
			//loading data
			currentPoints=0;
			currentSteps=0;

			//reset to show card front
			$('.cardfront').css({'transform':''},{'background-image':''},{'background-color':''});
			$('.cardback').css({'transform':''},{'background-image':''},{'background-color':''});
			console.log('reset!');
			

			//loading image
			images=['img/1.png','img/2.png','img/3.png','img/4.png',
								'img/5.png','img/6.png','img/7.png','img/8.png',
								'img/1.png','img/2.png','img/3.png','img/4.png',
								'img/5.png','img/6.png','img/7.png','img/8.png'];

			//initialize each card div
			for (var i = 0; i < cards.length; i++) {
				//make frontface class with random background color
				var randomcolor=color[Math.floor(Math.random()*color.length)];
				$(cards[i]).children().first().css('background-color',randomcolor);

				//make backface class with random background image
				var randomindeximages=Math.floor(Math.random()*images.length);
				var getimage=images[randomindeximages];
				$(cards[i]).children().last().css('background-image','url('+getimage+')');
				//remove the images already assigned
				images.splice(randomindeximages,1);
			};

			//initial temps to hold images and card id
			tempimages=[];
			tempcards=[];
			matchCard=0;
			currentPoints=0;
			currentSteps=0;
			console.log(tempcards);
		}
		
		//auto flip back different cards
		var autoflipCard =  function(){
			//set timer for auto flip cards
			setTimeout(function(){ 
				//flip card back to show front color and remove 'flipped' marks from cards
				if(tempimages[0]!==tempimages[1]) {
					flipCardback();
					$('.card.flipped').removeClass('flipped');

				//if both of matching cards have the same image then no need to flip back and just remove 'flipped' marks from cards
				} else if(tempimages[0]===tempimages[1]) {
					$('.card.flipped').removeClass('flipped');
					currentPoints=currentPoints+1;
					console.log('currentPoints: '+currentPoints);
				} 

				//reset matchCard
				matchCard=0;
				console.log('matchCard: '+matchCard);
				tempimages=[];
				console.log('tempimages: '+tempimages);
				currentSteps=currentSteps+1;
				console.log('currentSteps: '+currentSteps);
				tempcards=[];

				//update game status
				updateGameStatus(currentPoints,totalSteps);
			}, 800);
		}
		
		//click to start card to reset cards
		$('#start').on('click',function(){
			//hide start card during the game
			$('#start').hide("slow");
			//show cards
			$('.card').children().show('slow');
			resetCard();
		});

		//click cards to trigger matching functions
		$('.card').on('click',function(){
			//check if steps run out
			if ((currentSteps<totalSteps)&&currentPoints<winPoints){
				//check if trigger the first matching card
				if( tempcards.length<2) {

					//get the triggered card id
					tempcards.push($(this).attr('id'));
					console.log(tempcards);
					console.log(tempcards.length);
					
					//mark the first matching card as 'flipped card' and flip card front to show back image
					$(this).addClass('flipped');
					flipCardfront();
					
					//count the first card
					matchCard=matchCard+1;
					console.log('matchCard: '+matchCard);
					
					//get the first triggered card back image
					tempimages.push($(this).children().last().css('background-image'));
					console.log('tempimages: '+tempimages);

					//check if trigger the second matching card
					if((tempcards.length>=2)&&(tempcards[1]!==tempcards[0])){
						
						//mark the second card and flip it to show the back image
						$(this).addClass('flipped');
						flipCardfront();
						
						//count the second card
						matchCard=matchCard+1;
						console.log('matchCard: '+matchCard);
						
						//get the second triggered card back image
						tempimages.push($(this).children().last().css('background-image'));
						console.log('tempimages: '+tempimages);
						
						//set timer to auto flip back different cards
						autoflipCard();

						//no count if the second triggered card is the same as the first one
					}	else if((tempcards.length>=2)&&(tempcards[1]===tempcards[0])){
						alert('The same card! Pick another one')
						tempcards.pop();
						tempimages.pop();
						matchCard=matchCard-1;
					}
				}//

				//check if still have steps while math the enough number cards
			} else if ((currentSteps<totalSteps)&&(currentPoints>=winPoints)){
				//remove cards and update game status and show the start card again
				$('.card').children().hide('slow');
				images=[];
				$('.gamestatus').html('<br>You win the game! <br><br> Want to play again?')
				$('#start').show("slow");

				//check if outrun the steps
			} else {
				//remove cards and update game status and show the start card again
				$('.card').children().hide('slow');
				images=[];
				$('.gamestatus').html('<br>You lose the game! <br><br> Try again!')
				$('#start').show("slow");
			} //check if steps run out
		});

	}

	$(document).ready(function(){
		gamestart();
	})
	
})();