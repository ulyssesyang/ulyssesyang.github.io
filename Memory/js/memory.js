"use strict";

(function () {

	
	var gamestart = function(){

		//initial data
		var color=['red','purple','lightgreen','gray','orange','darkred','blue','yellow','brown','lightblue'];
		var cards=$('.card');
		var clickCardTwice=0;
		var winPoints=7;
		var currentPoints=0;
		var totalSteps=12;
		var currentSteps=0;
		var images=[];
		var difficulty='medium';

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

		//flip Card
		var flipCard = function(){
			
			$('.card.flipped .cardback').css({transform:'rotateY(0deg)'},1000);
			$('.card.flipped .cardfront').css({transform:'rotateY(-180deg)'},1000);
		}

		//default difficulty is easy
		updateGameRule(difficulty,totalSteps,winPoints);

		//choose difficulty
		var levelmenu = $(".levelmenu");
	  levelmenu.hover(function(){
	  		$('.levelmenu').children('a').addClass("hover")
	  		$('.ChooseDifficulty').show();
	  }, function(){
	  		if($('.levelmenu').hasClass('hover')!==true){
	  			$('.levelmenu').children('a').removeClass("hover");
	    		$('.ChooseDifficulty').delay(1000).hide(0);
	  		} else {
	  			$('.levelmenu').removeClass("hover");
	    		$('.ChooseDifficulty').delay(1000).hide(0);
	  		}
	  });

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

		
		$('.start').css('background-color',color[Math.floor(Math.random()*color.length)]);
		$('.card').children().hide();
		
		
		//click to start game
		$('#start').on('click',function(){

			//hide start button during the game
			$('#start').hide("slow");

			//loading data
			currentPoints=0;
			currentSteps=0;
			$('.card.flipped').removeClass('flipped');
			$('.card').children().show('slow');
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
				images.splice(randomindeximages,1);
			};

			var tempimages=[];
			var temptarges=[];

			$('.card').on('click',function(){

				temptarges.push($(this).attr('id'));
				console.log(temptarges);

				if ((currentSteps<totalSteps)&&currentPoints<winPoints){

					if( temptarges.length<2) {
						
						$(this).addClass('flipped');
						flipCard();
						
						clickCardTwice=clickCardTwice+1;
						console.log('clickCardTwice: '+clickCardTwice);
						
						tempimages.push($(this).children().last().css('background-image'));
						console.log('tempimages: '+tempimages);

					} else if((temptarges.length>=2)&&(temptarges[1]!==temptarges[0])){
						
						$(this).addClass('flipped');
						flipCard();
						
						clickCardTwice=clickCardTwice+1;
						console.log('clickCardTwice: '+clickCardTwice);
						
						tempimages.push($(this).children().last().css('background-image'));
						console.log('tempimages: '+tempimages);
						
						temptarges=[];

						setTimeout(function(){ 

							if(tempimages[0]!==tempimages[1]) {
								$('.card.flipped .cardback').css({transform:'rotateY(-180deg)'},1000);
								$('.card.flipped .cardfront').css({transform:'rotateY(0deg)'},1000);
								$('.card.flipped').removeClass('flipped');


							} else if(tempimages[0]===tempimages[1]) {
								$('.card.flipped').removeClass('flipped');
								currentPoints=currentPoints+1;
								console.log('currentPoints: '+currentPoints);
							} 

							clickCardTwice=0;
							console.log('clickCardTwice: '+clickCardTwice);
							tempimages=[];
							console.log('tempimages: '+tempimages);
							currentSteps=currentSteps+1;
							console.log('currentSteps: '+currentSteps);

						}, 1000);

					}	else if((temptarges.length>=2)&&(temptarges[1]===temptarges[0])){
						alert('the same card! <br> pick another one')
						temptarges.pop();
					}

					updateGameStatus(currentPoints,totalSteps);

				} else  

				if(currentPoints>=winPoints){
					$('.card').children().hide('slow');
					images=[];
					$('.gamestatus').html('<br>You win the game! <br><br> Want to play again?')
					$('#start').show("slow");
				}
				
				if(currentSteps>=totalSteps){
					$('.card').children().hide('slow');
					images=[];
					$('.gamestatus').html('<br>You lose the game! <br><br> Try again!')
					$('#start').show("slow");
				}

				if(currentSteps<totalSteps) {
					
				}
				
			});


		});
		

	}

	$(document).ready(function(){
		gamestart();
	})
	
})();