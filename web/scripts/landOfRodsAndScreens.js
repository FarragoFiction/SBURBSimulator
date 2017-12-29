var screens = [];
var maxState = 158; //this number MUST be even.
var imagesWaiting = 0;
var imagesLoaded = 0;
var targetImage = 0; //what could control this???
var ti1 = 0;
var ti2 = 0;
var ti3 = 0;
var ti4 = 0;
var x = [];
var janusNum = 0;
var eggsSolution = false;
var eggs = {};
var timeTillReckoning = 99999999999999999999;  //take as long as you want...for now.
var reachedTarget = false;
var failureEnding = false;
var denizenEnding = false;

var distactions = new Array(maxState); //all images, screen responsible for displaying it's chunk
//figure out a number of turns until the reckoning. make it more than you'd reasonably need to solve it
//so only if they get distracted does it turn deadly.
//each image you unlock has jr make a comment on the image, and gives you a hint about how to
//get to the denizen to have the puzzle just solved for you. (for a price)

window.onload = function() {
	setTimeout(function() {window.scrollTo(0, 0);},1) //because chrome is a special snowlake (refrance)
	Math.seed = 3;
	initializeX();
	makeScreens(256);
	loadAllImages();
	//think for 5 minutes on the clock before activating cheat powers.
	//(have some easter egg way to activate them immediately for those who are playing it a second time.)
	setTimeout(function(){
		showMindButton();
	}, (5*60000));
}

function showMindButton(){
	$("#spiel").hide();
	$("#mindButton").show();
}


//A TIME LIMIT!? That's BULLSHIT!
//it's...ALMOST like you're expected to use your phenomenal cosmic powers to BEAT THE GAME
//and not dick around looking for easter eggs!!!
function doTheMindyThing(){
	$("#mindButton").hide();
	timeTillReckoning = 4; //you can find a few pictures, but then you better focus up.
	$("#slider").html('Look for Image: <span id="imageValue">64</span> <Br> 0 <input id="targetImage" type="range" min="0" max="'+ (maxState-1) + '" value="64"> '+ (maxState-1) + '<br><button id="concentrate">Concentrate</button>');
	$("#mindPowers").show();
	$("#targetImage").change(function(){
		$("#imageValue").html($("#targetImage").val());
	});

	$("#concentrate").click(function(){
		$("#concentrate").prop('disabled', true)
		concentrate($("#targetImage").val());
	});
}

function initializeX(){
	for(var i = 0; i< 3; i++){
		x.push([maxState, maxState, maxState]);
	}
}


/*
		Thanks goes to DilletantMathematician for designing the math behind this.
		There were a lot of ways I could have done this, but this one is mathematically guaranteed
		to be able to reach every easter egg.  :) :) :)

		and also, probably just as hard to figure out as the damn puzzle
*/

function knob1(){
	ti1 ++;
	if(ti1 > 3) ti1 = 0;
	recalcTI();
}

function knob2(){
	ti2 ++;
	if(ti2 > 3) ti2 = 0;
	recalcTI();
}

function knob3(){
	ti3 ++;
	if(ti3 > 3) ti3 = 0;
	recalcTI();
}

function knob4(){
	ti4 ++;
	if(ti4 > 3) ti4 = 0;
	recalcTI();
}


//k = 0
function button1(){
	$("#b1").attr("src", "images/LORAS/ControlPanel/button_1_p011.png");
	compute(0,ia);
	setTimeout(function(){
		$("#b1").attr("src", "images/LORAS/ControlPanel/button_1_p01.png");
	},200);
}

//k = 0
function button2(){
	$("#b2").attr("src", "images/LORAS/ControlPanel/button_1_p021.png");
	setTimeout(function(){
		$("#b2").attr("src", "images/LORAS/ControlPanel/button_1_p02.png");
	},200);
	compute(0,fhtagn);

}


// k = 1
function button3(){
	$("#b3").attr("src", "images/LORAS/ControlPanel/button_2_p011.png");
	setTimeout(function(){
		$("#b3").attr("src", "images/LORAS/ControlPanel/button_2_p01.png");
	},200);
	compute(1,ia);
}

//k = 1
function button4(){
	$("#b4").attr("src", "images/LORAS/ControlPanel/button_2_p021.png");
	setTimeout(function(){
		$("#b4").attr("src", "images/LORAS/ControlPanel/button_2_p02.png");
	},200);
	compute(1,fhtagn);
}

//k = 2
function button5(){
	$("#b5").attr("src", "images/LORAS/ControlPanel/button_3_p011.png");
	setTimeout(function(){
		$("#b5").attr("src", "images/LORAS/ControlPanel/button_3_p01.png");
	},200);
	compute(2,ia);
}

//k = 2
function button6(){
	$("#b6").attr("src", "images/LORAS/ControlPanel/button_3_p021.png");
	setTimeout(function(){
		$("#b6").attr("src", "images/LORAS/ControlPanel/button_3_p02.png");
	},200);
	compute(2,fhtagn);
}


function recalcTI(){
	//make DAMN sure knobs aren't an invalid number.
	if(ti1 > 3) ti1 = 0;
	if(ti2 > 3) ti2 = 0;
	if(ti3 > 3) ti3 = 0;
	if(ti4 > 3) ti4 = 0;
	//console.log("ti1: " + ti1 + " ti2: " + ti2 + " ti3 " + ti3 + " ti4: " + ti4)
	targetImage = Math.floor(ti1 + (ti2 <<2) + (ti3<<4) + (ti4<<6)); //uses 16 digits to make a 256 number.
	//console.log(targetImage)
	if(targetImage > maxState) targetImage = maxState; //cluster up around the black screens.
	//console.log(targetImage)
	drawKnobs();

}

//this should happen if even. look at me, being so generous with my hints
//(the joke is that this is fucking giberish that took me an entire day to understand enough to program)
//(and I STILL do not understand enough to explain to a human. computers are much easier to explain things to)
function ia(k,nk){
	//console.log("ia"+k);
	if(nk%2 != 0){
		//punishment. (maybe show on screen in some way)
		console.log("WRONG!!!")
		x[k][2] = getRandomInt(0, maxState); //NOW you fucked up!  (i mean, probably, i am still fuzzy on what x even does.)
	}
	return nk/2;
}

//this should happen if odd.
function fhtagn(k,nk){
	//console.log("fhtagn"+k)
	if(nk%2 == 0) console.log("WRONG!!!")
	return nk*3 + 1;
}

function checkReckoning(){
	if(timeTillReckoning == 0){
		timeTillReckoning = -1 //don't keep doing this.
		distactions[0] = distactions[1026];
		failureEnding = true;
		alert("The Reckoning is over. You have failed to pass your Land Quest in time to help your team mates. But you can always keep obsessing over this Puzzle, for as long as you live. It's not like you can ever leave the Medium without a frog, after all.")
	}
}

function calculateN(k,yk){
	checkReckoning();
	var q = maxState;
	var ret = 1;
	//N[k] = 1 + sum(  y[k][i]*(q**i) for i in range(3))
	for(var i = 0; i<yk.length; i++){
		//ret += yk[i]*(q**i)  ///WHY??? DM, you are a crazy, crazy mathematician.
		//chrome doesn't know what ** is like an asshole???

		ret += yk[i]*Math.pow(q,i)   ///WHY??? DM, you are a crazy, crazy mathematician.
	}
	return ret;
}


//https://en.wikipedia.org/wiki/Collatz_conjecture
function compute(k, formula){
	//console.log("computing")
	var q = maxState;
	var yk = new Array(3);
	for(var i = 0; i<yk.length; i++){
		yk[i] = (x[k][i] - targetImage + q) % q
	}
	var nk = calculateN(k, yk);
	//console.log(["N="+nk, yk, x[k]])
	var newnk = formula(k,nk);
	var newyk = []
	var newxk = [];  //do i replace this in x, or is it temp?
	for(var i = 0; i<yk.length; i++){
		newyk[i] = Math.floor((newnk-1)/Math.pow(q,i) );
		newxk[i] = (newyk[i] + targetImage) % q
	}
	x[k] = newxk;
	//then, finally, get all screens who match k, and set their values according to x[k][i] or whatever.
	updateScreens(k);
	checkScreens();
}

function toggleGuides(){
	for(var i = 0; i<screens.length; i++){
		screens[i].toggleGuides();
	}
}

function updateScreens(k){
	for(var i = 0; i<screens.length; i++){
		if(screens[i].k == k){
			screens[i].changeState(x[k][screens[i].i]);
		}
	}
}

function loadAllImages(){
	for(var i = 0; i< maxState+1; i++){
		loadImage('images/LORAS/'+i+".png",i);
	}
	loadImage('images/LORAS/0Ultimate.png',1025);
	loadImage('images/LORAS/0Fail.png',1026);
}

function loadImage(img,i){
	imagesWaiting ++;
	var imageObj = new Image();
  imageObj.onload = function() {
			imagesLoaded ++;
			checkDone();
  };
	distactions[i] =  imageObj;

  imageObj.onerror = function(){
    debug("Error loading image: " + this.src)
		console.log("Error loading image: " + this.src);
  }
  imageObj.src = img;
}

function start(){
	renderLoop();
}

function checkDone(skipInit){
  $("#loading_stats").html("Images Loaded: " + imagesLoaded);
	if(imagesLoaded != 0 && imagesWaiting == imagesLoaded){
		start();
	}
}



function justFuckingRandomize(){
	for(var i = 0; i<screens.length; i++){
		screens[i].randomizeState();
	}
}


function changeStateForAllScreens(state){
	for(var i = 0; i<screens.length; i++){
		screens[i].state = state;
	}
}

function renderLoop(){
	for(var i = 0; i<screens.length; i++){
		screens[i].display();
	}
}

//css will handle putting them into a grid, don't worry about it.
function makeScreens(number){
		for(var i = 0; i< number; i++){
			var html = "<canvas class = 'screen' id = 'screen" + i + "' width = '45' height = '45'></canvas>";
			$("#landScreens").append(html);
			var uX = i%16 * 45;
			var uY = Math.floor(i/16) * 45;
			var iMatrix = 0;
			var kMatrix = 0;
			if(i == 1){
				iMatrix = 1;
			} else if (i == 2){
				iMatrix = 2
			}else{
				iMatrix = i%3;
				kMatrix = Math.floor(i/3)%3;
			}
			screens[i]=new Screen(document.getElementById("screen"+i),maxState, uX, uY, i, iMatrix, kMatrix);
		}
		for(var i = 0; i< number; i++){
			var canvas = $("#screen"+i);
			var screen = screens[i];
			wireUpScreen(canvas, screen);
		}
}

function wireUpScreen(canvas, screen){
	if(screen.screenNum == 193)		egg1(canvas, screen,2);
	if(screen.screenNum == 196)		egg1(canvas, screen,5);
	if(screen.screenNum == 199)		egg1(canvas, screen,6);
	if(screen.screenNum == 202)		egg1(canvas, screen,9);
	if(screen.screenNum == 205)		egg1(canvas, screen,10);
	if(screen.screenNum == 146)		egg1(canvas, screen,13);
	if(screen.screenNum == 149)		egg1(canvas, screen,15);
	if(screen.screenNum == 152)		egg1(canvas, screen,12);
	if(screen.screenNum == 155)		egg1(canvas, screen,11);
	if(screen.screenNum == 158)		egg1(canvas, screen,8);
	if(screen.screenNum == 127)		egg1(canvas, screen,7);
	if(screen.screenNum == 125)		egg1(canvas, screen,4);
	if(screen.screenNum == 123)		egg1(canvas, screen,3);
	if(screen.screenNum == 121)		egg1(canvas, screen,1);
	if(screen.screenNum == 119)		egg1(canvas, screen,14);
}

function egg1(canvas, screen,num){
	canvas.click(function(){
		processEgg(num);
	})
}

//janus is a bad listener.
function talkJanus(){
	if(janusNum == 0) console.log("Janus1: It's about time you found me. Harumph.  Talk back by typing: 'talkJanus('thing you want to say in quotes')'.  Now, do you want the Solution?");
	if(janusNum == 1) console.log("Janus1: Of course you do. Kids these days have no respect for artistry. Do you know how HARD it was to come up with that puzzle? Don't answer that. If you want the Solution, then you will have to give me a Solution of your own. I'm sure you noticed how the control panel changed.  That's what got my attention.  I can't figure out how to get all the control panel symbols lit up.  Do this for me, and I will show you how to beat the puzzle.");
	if(janusNum > 1 && !eggsSolution) console.log("Janus1: Consarn it! Would you leave me alone if you haven't got my Solution yet?")
	if(janusNum > 1 && eggsSolution){
		console.log("Janus1: Well hot damn! You did it! Gives me hope for the next generation, is what it does. ")
		console.log("Janus2:  If you had even attempted to think about the puzzle yourself, dear brother, you would have found the solution to be obvious. ")
		console.log("Janus2:  And now it falls to me to honor the promises you have made, in your haste to prove your ignorance. ")
		console.log("Janus1: Well ain't you a breath of fresh air! I haven't heard you talk in a DOG's age!")
		console.log("Janus2:  *sigh* I will give you your Solution, Observer, that you may marvel in the mind that TRULY designed this Challenge. ")
		distactions[0] = distactions[1025];
		denizenEnding = true;
		denizenCheat();
	}
	janusNum ++;
}

function janus(){
	console.log("There is an ominous rumbling from below as a secret passage opens beneath your feet. You unceremoniously tumble down to the center of LORAS and land in a heap in front of a terrifyingly huge figure.")
	$.ajax({
	  url: "janus.txt",
	  success:(function(data){
		  console.log(data)
		  talkJanus();
	  }),
	  dataType: "text"
	});

}

function concentrate(target){
	if(reachedTarget){
		reachedTarget = false
		 return;
	}
	//inverse targetImage = Math.floor(ti1 + (ti2 <<2) + (ti3<<4) + (ti4<<6)); //uses 16 digits to make a 256 number.
	ti1 = 3&(target);
	ti2 = 3&(target >> 2);
	ti3 = 3&(target >> 4);
	ti4 = 3&(target >> 6);
	recalcTI();
	blatantlyCheat(ti1,ti2,ti3,ti4);
	setTimeout(function(){
		concentrate(target);
	},1000);

}

//Hey, man, this is a Quest designed to spit out 4th wall breaking Wastes
//Of COURSE cheating is encouraged.
//denizen will only let you target state 0.
//mind powers will let you target any state.
function blatantlyCheat(t1,t2,t3,t4){
	//console.log("winning via meta shenanigans")
	ti1 = t1;
	ti2 = t2;
	ti3 = t3;
	ti4 = t4;
	recalcTI();
	var odd = [button1, button3, button5]
	var even = [button2, button4, button6]
	//inverse for odd targets.
	if(targetImage %2 != 0){
		odd =  [button2, button4, button6]
		even =  [button1, button3, button5]
	}
	//console.log(["cheating", even, odd])
	setTimeout(function(){
		cheat1(even, odd);
	},200);
}

function denizenCheat(){
	if(reachedTarget || !eggsSolution) return;
	blatantlyCheat(0,0,0,0);
	setTimeout(function(){
		denizenCheat();
	},1000);
}

function cheat1(even, odd){
	if(screens[0].state != targetImage || screens[1].state != targetImage || screens[2].state != targetImage){
		if(screens[0].state % 2 == 0){
			even[0]();
		}else{
			odd[0]();
		}
	}
	setTimeout(function(){
		cheat2(even, odd);
	},200);
}

function cheat2(even, odd){
	if(screens[3].state != targetImage || screens[4].state != targetImage || screens[5].state != targetImage){
		if(screens[3].state %2 == 0){
			even[1]();
		}else{
			odd[1]();
		}
	}
	setTimeout(function(){
		cheat3(even, odd);
	},200);
}

function cheat3(even, odd){
	if(screens[6].state != targetImage || screens[7].state != targetImage || screens[8].state != targetImage){
		if(screens[6].state % 2 == 0){
			even[2]();
		}else{
			odd[2]();
		}
	}
}

function checkScreens(){
	var state = screens[0].state;
	for(var i = 0; i<screens.length; i++){
		if(screens[i].state != state) return;
	}
	if(state == targetImage){
		reachedTarget = true;
		$("#concentrate").prop('disabled', false)
	}
	timeTillReckoning += -1;
	//alert("!!! you unlocked a picture! I need to do something here.")
	if(state == 0){
		showMindButton(); //want to show avatar to give you prize
		doTheMindyThing();
		$("#slider").hide();
	}
	quip(state);
}

function quip(state){
	var ret = ""
	var prize = ":/ Looks like you didn't do it before the Reckoning, though. Thems the breaks. Poor Janus died in vain. What were you even gonna DO with all that grist?";
	if(!failureEnding && !denizenEnding)
	{
		prize = "And you managed to it BEFORE the Reckoning! Look at you, being all 'adult' and shit. (I wonder if you missed any secrets, though.)  <Br><Br>Well, I guess I can give you a SMALL secret. Here you go: <a target = '_blank' href = 'index2.html?COOLK1D=true&MindStuck=true&SeerStuck=true&hive=bent'>WHO DO3S TH1S R3M1ND YOU OF???</a> "
	}else if(denizenEnding){
		prize = "And you found the Ultimate Secret that makes you worthy of a meta class like Waste.  <br><Br> Holy shit, apparently I got a YellowYard for beating Janus?  Huh...but for some reason I have to give it to you?  So...uh...don't fuck this up, okay: <Br><br><a target = '_blank' href = 'index2.html?lawnring=yellow'>UseYellowYardResponsibly</a>  "
	}
	if(state == 0){
	 ret = "Oh! You win! " + prize;
 	}else if(state == 47){
		ret = "Oh yeah! That was the image KR made as one of the possible backgrounds for the AB/JR newsposts. Kinda cheruby-huh?"
	}
	else if(state == 3){
		ret = "Huh? That doesn't look like RS..."
	}else if(state == 4){
		ret = "!!! I take back every complaint I ever made, this is truly the greatest possible planet.  Oh god, maybe I can find a way to get the audio going, Rick Roll all these consorts."
	}else if(state == 6){
		ret = "Shit, I hope this stupid thing doesn't work the way Prospit's clouds apparently do. Whoever that is is NOT having a good day."
	}else if(state == 7){
		ret = "Eeee, why is LORAS making chibi pictures of me and KR? And what's that yellow thing?"
	}else if(state == 8){
		ret = "Huh? Who is that random Time player? Is this a clue? A view of the future? Where even *am* I?"
	}else if(state == 9){
		ret = "Huh, apparently there are other people playing SBURB? I sure don't recognize those trolls. Jegus, I hope this doesn't mean a THIRD session is gonna crash into the Medium :/"
	}else if(state == 10 || state == 11 || state == 13 || state == 14 || state == 15 || state == 53 ){
		ret = "Cat!!!"
	}else if(state == 16){
		ret = "...I am ONTO you Squiddles. You can't fool me.  Man. I wish the Observers would stop trying to convince me that they just wanna be friends with all those players."
	}else if(state == 17 || state == 18 || state == 19 || state == 20 || state == 21){
		ret = "Oh god....they should have sent a poet. The words won't come. So beautiful."
	}else if(state == 22 || state == 23){
		ret = "It keeps hapening."
	}else if(state == 27){
		ret = "Damn, that land looks dope as shit."
	}else if(state == 29){
		ret = "Hrmmm...that reminds me, I wonder if prominentSpacer figured out the frog breeding yet..."
	} else if(state == 31 || state == 32 || state == 35 || state == 36 || state == 55){
		ret = "!!! Oh no! What's going on with dear sweet precious sweet sweet AuthorBot!??? This better not fucking be prophetic, like Prospit's shitty clouds."
	} else if(state == 39){
		ret = "Hopy shit, that is a LOT of SBURB players. Is that the afterlife???"
	} else if(state == 50){
		ret = "!!! Holy fuck, that better not happen to Prospit. Seriously. Where is LORAS even GETTING these images?"
	} else if(state == 51){
		ret = "!!!  I am not believing you, mysterious blood colored text, that dude is DEAD. Why am I even SEEING this?"
	} else if(state == 52){
		ret = "!!! So COOL!"
	} else if(state == 60 || state == 62){
		ret = "Jegus fuck, ABJ, stop being a creeper. Where did I program you wrong?"
	} else if(state == 61){
		ret = "*insert giggle snort here*"
	} else if(state == 63){
		ret = "Best troll!"
	} else if(state == 64){
		ret = "Don't worry about it, Observer, you have the reins here, it'll be fiiine.  What's ONE more secret?"
	} else if(state == 67){
		ret = "lol, i remember when that Observer figured out how to 'hack' SBURB.  So amazing."
	} else if(state == 65){
		ret = "Oh my FUCKING god, now LORAS is just trolling me."
	} else if(state == 67){
		ret = "True beauty."
	} else if(state == 70){
		ret = "Wait wait wait, what the fuck? How would you even SEE that???"
	} else if(state == 71){
		ret = "Holy fuck...meet the guest star of my next nightmare."
	} else if(state == 72){
		ret = "Wait. Are you telling me there are SECRETS in this shitty puzzle???"
	} else if(state == 73){
		ret = "Whoa...that makes me dizzy."
	} else if(state == 76){
		ret = "Eggs!!!"
	} else if(state == 87){
		ret = "!!! I still haven't done the eggs!"
	} else if(state == 88){
		ret = "Lol, that sure does look mysterious!!!"
	} else if(state == 90){
		ret = "Man...why is SBURB so obsessed with make outs?"
	} else if(state == 97){
		ret = "..."
	} else if(state == 98){
		ret = "Oh my god...how have I lived so long without those dope as fuck penguins?"
	} else if(state == 99){
		ret = "Best bulbasaur!"
	} else if(state == 101){
		ret = "Holy shit, how old IS that picture???"
	} else if(state == 110){
		ret = "Holy shit, classic 'You're Welcome' x2 combo. I added the cod piece as an easter egg AND I am showing you the way to turn on the Mindy Thing without waiting for 5 whole minutes. Truly, my magnanimity is breath taking."
	} else if(state == 116){
     		ret = "Holy fuck, I remember this. That denizen just fucking absconded mid boss fight. Kicked out the player and took their entire lair with them and rocked off into space.  So fucking weird."
    } else if(state == 122){
          		ret = "What the actual FUCK is that!???"
    } else if(state == 126 || state == 126 || state == 120 || state == 129){
          		ret = "Ummm...shit. Is LORAS...asking me to KILL it??? Too spoopy for me."
    } else if(state == 128){
        ret = "Whoa, I've heard of this! Those are the First Players in Multiverse D!!!"
    } else if(state == 131){
                  ret = "Sounds legit."
    } else if(state == 136){
        ret = "Huh, so that's what happened to all of AB's chassis. I am gonna hafta have a word with ABJ."
    }
      else if(state == 156){
             ret = "Huh. I only recognize a few of those people. Is this the future???"
         }else if(state == 142 || state == 143){
             ret = "!!! It's <a href = 'https://charahub.com/character/1140409/Kilius-Koplan'>Kilius!</a> The best troll!!!"
     }else{
		ret = "???"
	}
	console.log("JR: " + ret)
	$("#quip").html(ret);
}



//on first egg, ALSO unlock jr.
//rest of eggs cause glow on panel.  get all eggs....secret???
function processEgg(num){
	//console.log(num)
	if(janusNum == 0) janus();
	eggs[num] = "found it!";
	drawKnobs();
	for(var i = 1; i<=15; i++){
		if(eggs[i] != "found it!")  return;
	}
	console.log("ANNOUNCMENT: ALL EGGS FOUND!")
	eggsSolution = true;

}


function drawKnobs(){
	for(var i = 1; i<=16; i++){
		if(eggs[i] == "found it!"){
			drawKnobPart(i,true);
		}else{
			drawKnobPart(i,false);
		}
	}
}

function drawKnobPart(knobNum,glowing){
	if(knobNum == 1) drawK1(glowing);
	if(knobNum == 2) drawK2(glowing);
	if(knobNum == 3) drawK3(glowing);
	if(knobNum == 4) drawK4(glowing);
	if(knobNum == 5) drawK5(glowing);
	if(knobNum == 6) drawK6(glowing);
	if(knobNum == 7) drawK7(glowing);
	if(knobNum == 8) drawK8(glowing);
	if(knobNum == 9) drawK9(glowing);
	if(knobNum == 10) drawK10(glowing);
	if(knobNum == 11) drawK11(glowing);
	if(knobNum == 12) drawK12(glowing);
	if(knobNum == 13) drawK13(glowing);
	if(knobNum == 14) drawK14(glowing);
	if(knobNum == 15) drawK15(glowing);
	if(knobNum == 16) drawK16(true);
}

function drawK1(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg1");
	imgDiv = $("#egg1");
	var num = "W0"
	if(glow) num = "A0"
	if(ti1 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num + "_p0.png";
	if(ti1 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti1 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti1 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK2(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg2");
	var num = "W1"
	if(glow) num = "A1"
	if(ti1 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti1 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti1 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti1 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK3(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg3");
	var num = "W2"
	if(glow) num = "A2"
	if(ti1 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti1 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti1 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti1 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK4(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg4");
	var num = "W3"
	if(glow) num = "A3"
	if(ti1 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti1 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti1 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti1 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK5(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg5");
	var num = "X0"
	if(glow) num = "B0"
	if(ti2 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti2 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p1.png";
	if(ti2 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti2 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK6(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg6");
	var num = "X1"
	if(glow) num = "B1"
	if(ti2 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti2 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti2 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti2 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK7(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg7");
	var num = "X2"
	if(glow) num = "B2"
	if(ti2 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti2 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti2 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti2 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK8(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg8");
	var num = "X3"
	if(glow) num = "B3"
	if(ti2 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti2 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti2 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti2 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK9(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg9");
	var num = "Y0"
	if(glow) num = "C0"
	if(ti3 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti3 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti3 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti3 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK10(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg10");
	var num = "Y1"
	if(glow) num = "C1"
	if(ti3 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti3 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p1.png";
	if(ti3 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti3 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK11(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg11");
	var num = "Y2"
	if(glow) num = "C2"
	if(ti3 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti3 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p1.png";
	if(ti3 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti3 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK12(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg12");
	var num = "Y3"
	if(glow) num = "C3"
	if(ti3 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti3 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti3 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti3 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK13(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg13");
	var num = "Z0"
	if(glow) num = "D0"
	if(ti4 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti4 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti4 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti4 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK14(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg14");
	var num = "Z1"
	if(glow) num = "D1"
	if(ti4 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti4 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p1.png";
	if(ti4 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti4 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p3.png";
	imgDiv.attr("src", replacementImage);
}

function drawK15(glow){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg15");
	var num = "Z2"
	if(glow) num = "D2"
	if(ti4 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti4 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti4 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti4 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}

//always glows.
function drawK16(){
	var replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = $("#egg16");
	var num = "D3" //always glowing, because it's dillenteMathematician's symbol.
	if(ti4 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti4 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti4 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti4 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



function loadImages(lastImage){
	var html = "";
	for(var i = 0; i<= lastImage; i++){
		html += "<img id = 'distaction"+i+"'style = 'display:none;' src = 'images/LORAS/" + i + ".png'>"
	}
	$("#loading_image_staging").append(html);

}


function getTemporaryCanvas(){
	var tmp_canvas = document.createElement('canvas');
	tmp_canvas.height = 720;
	tmp_canvas.width = 720;
	return tmp_canvas;
}


function Screen(canvas,maxState, uX, uY, screenNum, i, k){
	this.canvas = canvas;
	this.maxState = maxState;
	this.state = maxState;
	this.screenNum = screenNum;
	this.upperLeftX = uX;
	this.drawGuides = false;
	this.upperLeftY = uY;
	this.height = 45; //<-- don't fucking change this.
	this.width = 45;
	//trying to figure @dillenteMathematicians' math.  math. man.
	this.i = i;
	this.k = k;

	this.randomizeState = function(){
		this.state = getRandomInt(0,maxState-1)
		//this.state = 0;
		this.display();
	}


	this.toggleGuides = function(){
		this.drawGuides = !this.drawGuides;
		this.display();
	}

	this.changeState = function(state){
		//console.log(state);
		if(state < 0){
			state = 0;
		} else if(state > this.maxState){
			state = maxState;
		}else{
			this.state = state;
		}
		this.display();
	}
	this.clearSelf = function(){
		var ctx = canvas.getContext('2d');
		ctx.clearRect(0, 0, this.width, this.height)
	}

	this.drawState = function(){
		if(!this.drawGuides) return;
		var ctx = canvas.getContext('2d');
		var x = this.width/4;
		//var x = 0;
		var y = this.height/2;
		ctx.fillStyle = "#000000";
		ctx.fillText(this.state,x,y);
		x += 1;
		y += 1;
		ctx.font = "20px Times New Roman"
		ctx.fillStyle = "#ffffff";
		ctx.fillText(this.state,x,y);
		//ctx.fillText(this.state + "<"+this.i+"," +this.k+">",x,y);
	}

	this.display = function(){
		//console.log("display: " + this.state);
		this.clearSelf();
	  var ctx = canvas.getContext('2d');
		var image = distactions[this.state];
		//console.log(image);
		ctx.drawImage(image, this.upperLeftX, this.upperLeftY, this.width, this.height, 0, 0, this.width, this.height);
		this.drawState();
	}
}
