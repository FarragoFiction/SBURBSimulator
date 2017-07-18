

List<dynamic> screens = [];
num maxState = 118; //this number MUST be even.
num imagesWaiting = 0;
num imagesLoaded = 0;
num targetImage = 0; //what could control this???
num ti1 = 0;
num ti2 = 0;
num ti3 = 0;
num ti4 = 0;
List<dynamic> x = [];
num janusNum = 0;
bool eggsSolution = false;
var eggs = {};
num timeTillReckoning = 99999999999999999999;  //take as long as you want...for now.
bool reachedTarget = false;
bool failureEnding = false;
bool denizenEnding = false;

var distactions = new Array(maxState); //all images, screen responsible for displaying it's chunk
//figure out a number of turns until the reckoning. make it more than you'd reasonably need to solve it
//so only if they get distracted does it turn deadly.
//each image you unlock has jr make a comment on the image, and gives you a hint about how to
//get to the denizen to have the puzzle just solved for you. (for a price)

window.onload = () {
	setTimeout(() {window.scrollTo(0, 0);},1) //because chrome is a special snowlake (refrance)
	Math.seed = 3;
	initializeX();
	makeScreens(256);
	loadAllImages();
	//think for 5 minutes on the clock before activating cheat powers.
	//(have some easter egg way to activate them immediately for those who are playing it a second time.)
	setTimeout((){
		showMindButton();
	}, (5*60000));
}

void showMindButton(){
	querySelector("#spiel").hide();
	querySelector("#mindButton").show();
}




//A TIME LIMIT!? That's BULLSHIT!
//it's...ALMOST like you're expected to use your phenomenal cosmic powers to BEAT THE GAME
//and not dick around looking for easter eggs!!!
void doTheMindyThing(){
	querySelector("#mindButton").hide();
	timeTillReckoning = 4; //you can find a few pictures, but then you better focus up.
	querySelector("#slider").html('Look for Image: <span id="imageValue">64</span> <Br> 0 <input id;="targetImage" type="range" min;="0" max="'+ (maxState-1) + '" value;="64"> '+ (maxState-1) + '<br><button id="concentrate">Concentrate</button>');
	querySelector("#mindPowers").show();
	querySelector("#targetImage").change((){
		querySelector("#imageValue").html(querySelector("#targetImage").val());
	});

	querySelector("#concentrate").click((){
		querySelector("#concentrate").prop('disabled', true);
		concentrate(querySelector("#targetImage").val());
	});
}



void initializeX(){
	for(int i = 0; i<3; i++){
		x.add([maxState, maxState, maxState]);
	}
}




/*
		Thanks goes to DilletantMathematician for designing the math behind this.
		There were a lot of ways I could have done this, but this one is mathematically guaranteed
		to be able to reach every easter egg.  :) :) :)

		and also, probably just as hard to figure out as the damn puzzle
*/

void knob1(){
	ti1 ++;
	if(ti1 > 3) ti1 = 0;
	recalcTI();
}



void knob2(){
	ti2 ++;
	if(ti2 > 3) ti2 = 0;
	recalcTI();
}



void knob3(){
	ti3 ++;
	if(ti3 > 3) ti3 = 0;
	recalcTI();
}



void knob4(){
	ti4 ++;
	if(ti4 > 3) ti4 = 0;
	recalcTI();
}




//k = 0;
void button1(){
	querySelector("#b1").attr("src", "images/LORAS/ControlPanel/button_1_p011.png");
	compute(0,ia);
	setTimeout((){
		querySelector("#b1").attr("src", "images/LORAS/ControlPanel/button_1_p01.png");
	},200);
}



//k = 0;
void button2(){
	querySelector("#b2").attr("src", "images/LORAS/ControlPanel/button_1_p021.png");
	setTimeout((){
		querySelector("#b2").attr("src", "images/LORAS/ControlPanel/button_1_p02.png");
	},200);
	compute(0,fhtagn);

}




// k = 1;
void button3(){
	querySelector("#b3").attr("src", "images/LORAS/ControlPanel/button_2_p011.png");
	setTimeout((){
		querySelector("#b3").attr("src", "images/LORAS/ControlPanel/button_2_p01.png");
	},200);
	compute(1,ia);
}



//k = 1;
void button4(){
	querySelector("#b4").attr("src", "images/LORAS/ControlPanel/button_2_p021.png");
	setTimeout((){
		querySelector("#b4").attr("src", "images/LORAS/ControlPanel/button_2_p02.png");
	},200);
	compute(1,fhtagn);
}



//k = 2;
void button5(){
	querySelector("#b5").attr("src", "images/LORAS/ControlPanel/button_3_p011.png");
	setTimeout((){
		querySelector("#b5").attr("src", "images/LORAS/ControlPanel/button_3_p01.png");
	},200);
	compute(2,ia);
}



//k = 2;
void button6(){
	querySelector("#b6").attr("src", "images/LORAS/ControlPanel/button_3_p021.png");
	setTimeout((){
		querySelector("#b6").attr("src", "images/LORAS/ControlPanel/button_3_p02.png");
	},200);
	compute(2,fhtagn);
}




void recalcTI(){
	//make DAMN sure knobs aren't an invalid number.
	if(ti1 > 3) ti1 = 0;
	if(ti2 > 3) ti2 = 0;
	if(ti3 > 3) ti3 = 0;
	if(ti4 > 3) ti4 = 0;
	//print("ti1: " + ti1 + " ti2: " + ti2 + " ti3 " + ti3 + " ti4: " + ti4);
	targetImage = Math.floor(ti1 + (ti2 <<2) + (ti3<<4) + (ti4<<6)); //uses 16 digits to make a 256 number.
	//print(targetImage);
	if(targetImage > maxState) targetImage = maxState; //cluster up around the black screens.
	//print(targetImage);
	drawKnobs();

}



//this should happen if even. look at me, being so generous with my hints
//(the joke is that this is fucking giberish that took me an entire day to understand enough to program)
//(and I STILL do not understand enough to explain to a human. computers are much easier to explain things to)
dynamic ia(k, nk){
	//print("ia"+k);
	if(nk%2 != 0){
		//punishment. (maybe show on screen in some way)
		print("WRONG!!!");
		x[k][2] = getRandomInt(0, maxState); //NOW you fucked up!  (i mean, probably, i am still fuzzy on what x even does.)
	}
	return nk/2;
}



//this should happen if odd.
dynamic fhtagn(k, nk){
	//print("fhtagn"+k);
	if(nk%2 == 0) print("WRONG!!!");
	return nk*3 + 1;
}



void checkReckoning(){
	if(timeTillReckoning == 0){
		timeTillReckoning = -1 ;//don't keep doing this.;
		distactions[0] = distactions[1026];
		failureEnding = true;
		alert("The Reckoning is over. You have failed to pass your Land Quest in time to help your team mates. But you can always keep obsessing over this Puzzle, for as long as you live. It's not like you can ever leave the Medium without a frog, after all.");
	}
}



dynamic calculateN(k, yk){
	checkReckoning();
	var q = maxState;
	num ret = 1;
	//N[k] = 1 + sum(  y[k][i]*(Math.pow(q, i)) for i in range(3));
	for(num i = 0; i<yk.length; i++){
		ret += yk[i]*(Math.pow(q, i))  /;//WHY??? DM, you are a crazy, crazy mathematician.;
	}
	return ret;
}




//https://en.wikipedia.org/wiki/Collatz_conjecture
void compute(k, formula){
	//print("computing");
	var q = maxState;
	var yk = new Array(3);
	for(num i = 0; i<yk.length; i++){
		yk[i] = (x[k][i] - targetImage + q) % q;
	}
	var nk = calculateN(k, yk);
	//print(["N="+nk, yk, x[k]]);
	var newnk = formula(k,nk);
	List<dynamic> newyk = [];
	List<dynamic> newxk = [];  //do i replace this in x, or is it temp?
	for(num i = 0; i<yk.length; i++){
		newyk[i] = Math.floor((newnk-1)/(Math.pow(q, i)));
		newxk[i] = (newyk[i] + targetImage) % q;
	}
	x[k] = newxk;
	//then, finally, get all screens who match k, and set their values according to x[k][i] or whatever.
	updateScreens(k);
	checkScreens();
}



void toggleGuides(){
	for(num i = 0; i<screens.length; i++){
		screens[i].toggleGuides();
	}
}



void updateScreens(k){
	for(num i = 0; i<screens.length; i++){
		if(screens[i].k == k){
			screens[i].changeState(x[k][screens[i].i]);
		}
	}
}



void loadAllImages(){
	for(num i = 0; i< maxState+1; i++){
		loadImage('images/LORAS/'+i+".png",i);
	}
	loadImage('images/LORAS/0Ultimate.png',1025);
	loadImage('images/LORAS/0Fail.png',1026);
}



class loadImage {

	loadImage(this.img, this.i) {}



	imagesWaiting ++;
	var imageObj = new Image();
  imageObj.onload = () {
			imagesLoaded ++;
			checkDone();
  };
	distactions[i] =  imageObj;

  imageObj.onerror = (){
    debug("Error loading image: " + this.src);
		print("Error loading image: " + this.src);
  }
  imageObj.src = img;
}



void start(){
	renderLoop();
}



void checkDone(skipInit){
  querySelector("#loading_stats").html("Images Loaded: " + imagesLoaded);
	if(imagesLoaded != 0 && imagesWaiting == imagesLoaded){
		start();
	}
}





void justFuckingRandomize(){
	for(num i = 0; i<screens.length; i++){
		screens[i].randomizeState();
	}
}




void changeStateForAllScreens(state){
	for(num i = 0; i<screens.length; i++){
		screens[i].state = state;
	}
}



void renderLoop(){
	for(num i = 0; i<screens.length; i++){
		screens[i].display();
	}
}



//css will handle putting them into a grid, don't worry about it.
void makeScreens(number){
		for(int i = 0; i<number; i++){
			String html = "<canvas class ;= 'screen' id = 'screen" + i + "' width ;= '45' height = '45'></canvas>";
			querySelector("#landScreens").append(html);
			var uX = i%16 * 45;
			var uY = Math.floor(i/16) * 45;
			num iMatrix = 0;
			num kMatrix = 0;
			if(i == 1){
				iMatrix = 1;
			} else if (i == 2){
				iMatrix = 2;
			}else{
				iMatrix = i%3;
				kMatrix = Math.floor(i/3)%3;
			}
			screens[i]=new Screen(querySelector("#screen"+i),maxState, uX, uY, i, iMatrix, kMatrix);
		}
		for(int i = 0; i<number; i++){
			var canvas = querySelector("#screen"+i);
			var screen = screens[i];
			wireUpScreen(canvas, screen);
		}
}



void wireUpScreen(canvas, screen){
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



void egg1(canvas, screen, num){
	canvas.click((){
		processEgg(num);
	})
}



//janus is a bad listener.
void talkJanus(){
	if(janusNum == 0) print("Janus1: It's about time you found me. Harumph.  Talk back by typing: 'talkJanus('thing you want to say in quotes')'.  Now, do you want the Solution?");
	if(janusNum == 1) print("Janus1: Of course you do. Kids these days have no respect for artistry. Do you know how HARD it was to come up with that puzzle? Don't answer that. If you want the Solution, then you will have to give me a Solution of your own. I'm sure you noticed how the control panel changed.  That's what got my attention.  I can't figure out how to get all the control panel symbols lit up.  Do this for me, and I will show you how to beat the puzzle.");
	if(janusNum > 1 && !eggsSolution) print("Janus1: Consarn it! Would you leave me alone if you haven't got my Solution yet?");
	if(janusNum > 1 && eggsSolution){
		print("Janus1: Well hot damn! You did it! Gives me hope for the next generation, is what it does. ");
		print("Janus2:  If you had even attempted to think about the puzzle yourself, dear brother, you would have found the solution to be obvious. ");
		print("Janus2:  And now it falls to me to honor the promises you have made, in your haste to prove your ignorance. ");
		print("Janus1: Well ain't you a breath of fresh air! I haven't heard you talk in a DOG's age!");
		print("Janus2:  *sigh* I will give you your Solution, Observer, that you may marvel in the mind that TRULY designed this Challenge. ");
		distactions[0] = distactions[1025];
		denizenEnding = true;
		denizenCheat();
	}
	janusNum ++;
}



void janus(){
	print("There is an ominous rumbling from below as a secret passage opens beneath your feet. You unceremoniously tumble down to the center of LORAS and land in a heap in front of a terrifyingly huge figure.");
	$.ajax({
	  url: "janus.txt",
	  success:((data){
		  print(data);
		  talkJanus();
	  }),
	  dataType: "text"
	});

}



void concentrate(target){
	if(reachedTarget){
		reachedTarget = false;
		 return;
	}
	//inverse targetImage = Math.floor(ti1 + (ti2 <<2) + (ti3<<4) + (ti4<<6)); //uses 16 digits to make a 256 number.
	ti1 = 3&(target);
	ti2 = 3&(target >> 2);
	ti3 = 3&(target >> 4);
	ti4 = 3&(target >> 6);
	recalcTI();
	blatantlyCheat(ti1,ti2,ti3,ti4);
	setTimeout((){
		concentrate(target);
	},1000);

}



//Hey, man, this is a Quest designed to spit out 4th wall breaking Wastes
//Of COURSE cheating is encouraged.
//denizen will only let you target state 0.
//mind powers will let you target any state.
void blatantlyCheat(t1, t2, t3, t4){
	//print("winning via meta shenanigans");
	ti1 = t1;
	ti2 = t2;
	ti3 = t3;
	ti4 = t4;
	recalcTI();
	var odd = [button1, button3, button5];
	var even = [button2, button4, button6];
	//inverse for odd targets.
	if(targetImage %2 != 0){
		odd =  [button2, button4, button6];
		even =  [button1, button3, button5];
	}
	//print(["cheating", even, odd]);
	setTimeout((){
		cheat1(even, odd);
	},200);
}



void denizenCheat(){
	if(reachedTarget || !eggsSolution) return;
	blatantlyCheat(0,0,0,0);
	setTimeout((){
		denizenCheat();
	},1000);
}



void cheat1(even, odd){
	if(screens[0].state != targetImage || screens[1].state != targetImage || screens[2].state != targetImage){
		if(screens[0].state % 2 == 0){
			even[0]();
		}else{
			odd[0]();
		}
	}
	setTimeout((){
		cheat2(even, odd);
	},200);
}



void cheat2(even, odd){
	if(screens[3].state != targetImage || screens[4].state != targetImage || screens[5].state != targetImage){
		if(screens[3].state %2 == 0){
			even[1]();
		}else{
			odd[1]();
		}
	}
	setTimeout((){
		cheat3(even, odd);
	},200);
}



void cheat3(even, odd){
	if(screens[6].state != targetImage || screens[7].state != targetImage || screens[8].state != targetImage){
		if(screens[6].state % 2 == 0){
			even[2]();
		}else{
			odd[2]();
		}
	}
}



void checkScreens(){
	var state = screens[0].state;
	for(num i = 0; i<screens.length; i++){
		if(screens[i].state != state) return;
	}
	if(state == targetImage){
		reachedTarget = true;
		querySelector("#concentrate").prop('disabled', false);
	}
	timeTillReckoning += -1;
	//alert("!!! you unlocked a picture! I need to do something here.");
	if(state == 0){
		showMindButton(); //want to show avatar to give you prize
		doTheMindyThing();
		querySelector("#slider").hide();
	}
	quip(state);
}



void quip(state){
	String ret = "";
	String prize = ":/ Looks like you didn't do it before the Reckoning, though. Thems the breaks. Poor Janus died in vain. What were you even gonna DO with all that grist?";
	if(!failureEnding && !denizenEnding);
	{
		prize = "And you managed to it BEFORE the Reckoning! Look at you, being all 'adult' and shit. (I wonder if you missed any secrets, though.)  <Br><Br>Well, I guess I can give you a SMALL secret. Here you go: <a target ;= '_blank' href = 'index2.html?COOLK1D;=true&MindStuck=true&SeerStuck;=true&hive=bent'>WHO DO3S TH1S R3M1ND YOU OF???</a> ";
	}else if(denizenEnding){
		prize = "And you found the Ultimate Secret that makes you worthy of a meta class like Waste.  <br><Br> Holy shit, apparently I got a YellowYard for beating Janus?  Huh...but for some reason I have to give it to you?  So...uh...don't fuck this up, okay: <Br><br><a target ;= '_blank' href = 'index2.html?lawnring;=yellow'>UseYellowYardResponsibly</a>  "
	}
	if(state == 0){
	 ret = "Oh! You win! " + prize;
 	}else if(state == 47){
		ret = "Oh yeah! That was the image KR made as one of the possible backgrounds for the AB/JR newsposts. Kinda cheruby-huh?";
	}
	else if(state == 3){
		ret = "Huh? That doesn't look like RS...";
	}else if(state == 4){
		ret = "!!! I take back every complaint I ever made, this is truly the greatest possible planet.  Oh god, maybe I can find a way to get the audio going, Rick Roll all these consorts.";
	}else if(state == 6){
		ret = "Shit, I hope this stupid thing doesn't work the way Prospit's clouds apparently do. Whoever that is is NOT having a good day.";
	}else if(state == 7){
		ret = "Eeee, why is LORAS making chibi pictures of me and KR? And what's that yellow thing?";
	}else if(state == 8){
		ret = "Huh? Who is that random Time player? Is this a clue? A view of the future? Where even *am* I?";
	}else if(state == 9){
		ret = "Huh, apparently there are other people playing SBURB? I sure don't recognize those trolls. Jegus, I hope this doesn't mean a THIRD session is gonna crash into the Medium :/";
	}else if(state == 10 || state == 11 || state == 13 || state == 14 || state == 15 || state == 53 ){
		ret = "Cat!!!";
	}else if(state == 16){
		ret = "...I am ONTO you Squiddles. You can't fool me.  Man. I wish the Observers would stop trying to convince me that they just wanna be friends with all those players.";
	}else if(state == 17 || state == 18 || state == 19 || state == 20 || state == 21){
		ret = "Oh god....they should have sent a poet. The words won't come. So beautiful.";
	}else if(state == 22 || state == 23){
		ret = "It keeps hapening.";
	}else if(state == 27){
		ret = "Damn, that land looks dope as shit.";
	}else if(state == 29){
		ret = "Hrmmm...that reminds me, I wonder if prominentSpacer figured out the frog breeding yet...";
	} else if(state == 31 || state == 32 || state == 35 || state == 36 || state == 55){
		ret = "!!! Oh no! What's going on with dear sweet precious sweet sweet AuthorBot!??? This better not fucking be prophetic, like Prospit's shitty clouds.";
	} else if(state == 39){
		ret = "Hopy shit, that is a LOT of SBURB players. Is that the afterlife???";
	} else if(state == 50){
		ret = "!!! Holy fuck, that better not happen to Prospit. Seriously. Where is LORAS even GETTING these images?";
	} else if(state == 51){
		ret = "!!!  I am not believing you, mysterious blood colored text, that dude is DEAD. Why am I even SEEING this?";
	} else if(state == 52){
		ret = "!!! So COOL!";
	} else if(state == 60 || state == 62){
		ret = "Jegus fuck, ABJ, stop being a creeper. Where did I program you wrong?";
	} else if(state == 61){
		ret = "*insert giggle snort here*";
	} else if(state == 63){
		ret = "Best troll!";
	} else if(state == 64){
		ret = "Don't worry about it, Observer, you have the reins here, it'll be fiiine.  What's ONE more secret?";
	} else if(state == 67){
		ret = "lol, i remember when that Observer figured out how to 'hack' SBURB.  So amazing.";
	} else if(state == 65){
		ret = "Oh my FUCKING god, now LORAS is just trolling me.";
	} else if(state == 67){
		ret = "True beauty.";
	} else if(state == 70){
		ret = "Wait wait wait, what the fuck? How would you even SEE that???";
	} else if(state == 71){
		ret = "Holy fuck...meet the guest star of my next nightmare.";
	} else if(state == 72){
		ret = "Wait. Are you telling me there are SECRETS in this shitty puzzle???";
	} else if(state == 73){
		ret = "Whoa...that makes me dizzy.";
	} else if(state == 76){
		ret = "Eggs!!!";
	} else if(state == 87){
		ret = "!!! I still haven't done the eggs!";
	} else if(state == 88){
		ret = "Lol, that sure does look mysterious!!!";
	} else if(state == 90){
		ret = "Man...why is SBURB so obsessed with make outs?";
	} else if(state == 97){
		ret = "...";
	} else if(state == 98){
		ret = "Oh my god...how have I lived so long without those dope as fuck penguins?";
	} else if(state == 99){
		ret = "Best bulbasaur!";
	} else if(state == 101){
		ret = "Holy shit, how old IS that picture???";
	} else if(state == 110){
		ret = "Holy shit, classic 'You're Welcome' x2 combo. I added the cod piece as an easter egg AND I am showing you the way to turn on the Mindy Thing without waiting for 5 whole minutes. Truly, my magnanimity is breath taking.";
	} else if(state == 116){
     		ret = "Holy fuck, I remember this. That denizen just fucking absconded mid boss fight. Kicked out the player and took their entire lair with them and rocked off into space.  So fucking weird.";
    }   else{
		ret = "???";
	}
	print("JR: " + ret);
	querySelector("#quip").html(ret);
}





//on first egg, ALSO unlock jr.
//rest of eggs cause glow on panel.  get all eggs....secret???
void processEgg(num){
	//print(num);
	if(janusNum == 0) janus();
	eggs[num] = "found it!";
	drawKnobs();
	for(int i = 1; i<=15; i++){
		if(eggs[i] != "found it!")  return;
	}
	print("ANNOUNCMENT: ALL EGGS FOUND!");
	eggsSolution = true;

}




void drawKnobs(){
	for(int i = 1; i<=16; i++){
		if(eggs[i] == "found it!"){
			drawKnobPart(i,true);
		}else{
			drawKnobPart(i,false);
		}
	}
}



void drawKnobPart(knobNum, glowing){
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



void drawK1(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg1");
	imgDiv = querySelector("#egg1");
	String num = "W0";
	if(glow) num = "A0";
	if(ti1 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num + "_p0.png";
	if(ti1 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti1 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti1 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK2(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg2");
	String num = "W1";
	if(glow) num = "A1";
	if(ti1 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti1 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti1 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti1 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK3(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg3");
	String num = "W2";
	if(glow) num = "A2";
	if(ti1 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti1 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti1 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti1 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK4(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg4");
	String num = "W3";
	if(glow) num = "A3";
	if(ti1 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti1 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti1 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti1 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK5(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg5");
	String num = "X0";
	if(glow) num = "B0";
	if(ti2 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti2 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p1.png";
	if(ti2 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti2 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK6(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg6");
	String num = "X1";
	if(glow) num = "B1";
	if(ti2 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti2 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti2 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti2 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK7(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg7");
	String num = "X2";
	if(glow) num = "B2";
	if(ti2 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti2 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti2 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti2 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK8(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg8");
	String num = "X3";
	if(glow) num = "B3";
	if(ti2 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti2 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti2 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti2 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK9(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg9");
	String num = "Y0";
	if(glow) num = "C0";
	if(ti3 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti3 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti3 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti3 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK10(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg10");
	String num = "Y1";
	if(glow) num = "C1";
	if(ti3 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti3 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p1.png";
	if(ti3 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti3 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK11(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg11");
	String num = "Y2";
	if(glow) num = "C2";
	if(ti3 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti3 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p1.png";
	if(ti3 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti3 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK12(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg12");
	String num = "Y3";
	if(glow) num = "C3";
	if(ti3 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti3 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti3 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti3 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK13(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg13");
	String num = "Z0";
	if(glow) num = "D0";
	if(ti4 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti4 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti4 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti4 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK14(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg14");
	String num = "Z1";
	if(glow) num = "D1";
	if(ti4 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti4 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p1.png";
	if(ti4 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti4 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num+ "_p3.png";
	imgDiv.attr("src", replacementImage);
}



void drawK15(glow){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg15");
	String num = "Z2";
	if(glow) num = "D2";
	if(ti4 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti4 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti4 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti4 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}



//always glows.
void drawK16(){
	String replacementImage = "images/LORAS/ControlPanel/knob_A0_p2.png";
	var imgDiv = querySelector("#egg16");
	String num = "D3" ;//always glowing, because it's dillenteMathematician's symbol.;
	if(ti4 == 0) replacementImage = "images/LORAS/ControlPanel/knob_" + num +"_p0.png";
	if(ti4 == 1) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p1.png";
	if(ti4 == 2) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p2.png";
	if(ti4 == 3) replacementImage =  "images/LORAS/ControlPanel/knob_" + num +"_p3.png";
	imgDiv.attr("src", replacementImage);
}





void loadImages(lastImage){
	String html = "";
	for(int i = 0; i<=lastImage; i++){
		html += "<img id ;= 'distaction"+i+"'style = 'display:none;' src = 'images/LORAS/" + i + ".png'>";
	}
	querySelector("#loading_image_staging").append(html);

}




dynamic getTemporaryCanvas(){
	var tmp_canvas = document.createElement('canvas');
	tmp_canvas.height = 720;
	tmp_canvas.width = 720;
	return tmp_canvas;
}




class Screen {
	var canvas;
	var maxState;
	var state;
	var screenNum;
	var upperLeftX;
	bool drawGuides = false;
	var upperLeftY;
	num height = 45; //<-- don't fucking change this.
	num width = 45;	//trying to figure @dillenteMathematicians' math.  math. man.
	var i;
	var k;	


	Screen(this.canvas, this.maxState, this.uX, this.uY, this.screenNum, this.i, this.k) {}


	void randomizeState(){
		this.state = getRandomInt(0,maxState-1);
		//this.state = 0;
		this.display();
	}
	void toggleGuides(){
		this.drawGuides = !this.drawGuides;
		this.display();
	}
	void changeState(state){
		//print(state);
		if(state < 0){
			state = 0;
		} else if(state > this.maxState){
			state = maxState;
		}else{
			this.state = state;
		}
		this.display();
	}
	void clearSelf(){
		var ctx = canvas.getContext('2d');
		ctx.clearRect(0, 0, this.width, this.height);
	}
	void drawState(){
		if(!this.drawGuides) return;
		var ctx = canvas.getContext('2d');
		var x = this.width/4;
		//num x = 0;
		var y = this.height/2;
		ctx.fillStyle = "#000000";
		ctx.fillText(this.state,x,y);
		x += 1;
		y += 1;
		ctx.font = "20px Times New Roman";
		ctx.fillStyle = "#ffffff";
		ctx.fillText(this.state,x,y);
		//ctx.fillText(this.state + "<"+this.i+"," +this.k+">",x,y);
	}
	void display(){
		//print("display: " + this.state);
		this.clearSelf();
	  var ctx = canvas.getContext('2d');
		var image = distactions[this.state];
		//print(image);
		ctx.drawImage(image, this.upperLeftX, this.upperLeftY, this.width, this.height, 0, 0, this.width, this.height);
		this.drawState();
	}

}
