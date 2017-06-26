var screens = [];
var maxState = 61;
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

var distactions = new Array(maxState); //all images, screen responsible for displaying it's chunk
//figure out a number of turns until the reckoning. make it more than you'd reasonably need to solve it
//so only if they get distracted does it turn deadly.
//each image you unlock has jr make a comment on the image, and gives you a hint about how to
//get to the denizen to have the puzzle just solved for you. (for a price)

window.onload = function() {
	Math.seed = 3;
	initializeX();
	makeScreens(256);
	loadAllImages();
	//you have one minute to try to solve it legit style before you get Mind powers.
	setTimeout(function(){
		$("#spiel").hide();
		$("#mindButton").show();
	}, 50000);
}

//A TIME LIMIT!? That's BULLSHIT!
//it's...ALMOST like you're expected to use your phenomenal cosmic powers to BEAT THE GAME
//and not dick around looking for easter eggs!!!
function doTheMindyThing(){
	timeTillReckoning = 100;
	$("#slider").html('Look for Image: <Br> 0 <input id="targetImage" type="range" min="0" max="'+ maxState + '" value="10"> '+ maxState + '');
	$("#mindPowers").show();
}


function initializeX(){
	for(var i = 0; i< 3; i++){
		x.push([getRandomInt(0, maxState),getRandomInt(0, maxState),getRandomInt(0, maxState) ]);
	}
}


/*
		Thanks goes to DilletantMathematician for designing the math behind this.
		There were a lot of ways I could have done this, but this one is mathematically guaranteed
		to be able to reach every easter egg.  :) :) :)

		and also, probably just as hard to figure out as the damn puzzle
*/

//k = 0
function button1(){
	$("#button1").attr("src", "images/LORAS/ControlPanel/button_1_p011.png");
	compute(0,ia);
	setTimeout(function(){
		$("#button1").attr("src", "images/LORAS/ControlPanel/button_1_p01.png");
	},200);
}

//k = 0
function button2(){
	$("#button2").attr("src", "images/LORAS/ControlPanel/button_1_p021.png");
	setTimeout(function(){
		$("#button2").attr("src", "images/LORAS/ControlPanel/button_1_p02.png");
	},200);
	compute(0,fhtagn);
	
}


// k = 1
function button3(){
	$("#button3").attr("src", "images/LORAS/ControlPanel/button_2_p011.png");
	setTimeout(function(){
		$("#button3").attr("src", "images/LORAS/ControlPanel/button_2_p01.png");
	},200);
	compute(1,ia);
}

//k = 1
function button4(){
	$("#button4").attr("src", "images/LORAS/ControlPanel/button_2_p021.png");
	setTimeout(function(){
		$("#button4").attr("src", "images/LORAS/ControlPanel/button_2_p02.png");
	},200);
	compute(1,fhtagn);
}

//k = 2
function button5(){
	$("#button5").attr("src", "images/LORAS/ControlPanel/button_3_p011.png");
	setTimeout(function(){
		$("#button5").attr("src", "images/LORAS/ControlPanel/button_3_p01.png");
	},200);
	compute(2,ia);
}

//k = 2
function button6(){
	$("#button6").attr("src", "images/LORAS/ControlPanel/button_3_p021.png");
	setTimeout(function(){
		$("#button6").attr("src", "images/LORAS/ControlPanel/button_3_p02.png");
	},200);
	compute(2,fhtagn);
}

function knob1(){
	ti1 ++;
	if(ti1 > maxState/4) ti1 = 0;
	recalcTI();
}

function knob2(){
	ti2 ++;
	if(ti2 > maxState/4) ti2 = 0;
	recalcTI();
}

function knob3(){
	ti3 ++;
	if(ti3 > maxState/4) ti3 = 0;
	recalcTI();
}

function knob4(){
	ti4 ++;
	if(ti4 > maxState/4) ti4 = 0;
	recalcTI();
}

function recalcTI(){
	//make DAMN sure knobs aren't an invalid number.
	if(ti1 > maxState/4) ti1 = 0;
	if(ti2 > maxState/4) ti2 = 0;
	if(ti3 > maxState/4) ti3 = 0;
	if(ti4 > maxState/4) ti4 = 0;
	targetImage = Math.floor(ti1 + ti2 + ti3 + ti4);
	console.log(targetImage)
}

//this should happen if even. look at me, being so generous with my hints
//(the joke is that this is fucking giberish that took me an entire day to understand enough to program)
//(and I STILL do not understand enough to explain to a human. computers are much easier to explain things to)
function ia(k,nk){
	//console.log("ia");
	if(nk%2 != 1){
		//punishment. (maybe show on screen in some way)
		console.log("WRONG!!!")
		x[k][2] = getRandomInt(0, maxState); //NOW you fucked up!  (i mean, probably, i am still fuzzy on what x even does.)
	}
	return nk/2;
}

//this should happen if odd.
function fhtagn(k,nk){
	//console.log("fhtagn")
	if(nk%2 == 1) console.log("WRONG!!!")
	return nk*3 + 1;
}

function checkReckoning(){
	if(timeTillReckoning == 0){
		alert("The Reckoning is over. You have failed to pass your Land Quest in time to help your team mates. But you can always keep obsessing over this Puzzle, for as long as you live. It's not like you can ever leave the Medium without a frog, after all.")
	}
}

function calculateN(k,yk){
	timeTillReckoning += -1;
	checkReckoning();
	var q = maxState;
	var ret = 1;
	//N[k] = 1 + sum(  y[k][i]*(q**i) for i in range(3))
	for(var i = 0; i<yk.length; i++){
		ret += yk[i]*(q**i)  ///WHY??? DM, you are a crazy, crazy mathematician.
	}
	return ret;
}


//https://en.wikipedia.org/wiki/Collatz_conjecture
function compute(k, formula){
	console.log("computing")
	var q = maxState;
	var yk = new Array(3);
	for(var i = 0; i<yk.length; i++){
		yk[i] = (x[k][i] - targetImage + q) % q
	}
	var nk = calculateN(k, yk);
	var newnk = formula(k,nk);
	var newyk = []
	var newxk = [];  //do i replace this in x, or is it temp?
	for(var i = 0; i<yk.length; i++){
		newyk[i] = Math.floor((newnk-1)/(q**i));
		newxk[i] = (newyk[i] + targetImage) % q
	}
	x[k] = newxk;
	//then, finally, get all screens who match k, and set their values according to x[k][i] or whatever.
	updateScreens(k);
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
	if(screen.screenNum == 193)		egg1(canvas, screen,1);
	if(screen.screenNum == 196)		egg1(canvas, screen,2);
	if(screen.screenNum == 199)		egg1(canvas, screen,3);
	if(screen.screenNum == 202)		egg1(canvas, screen,4);
	if(screen.screenNum == 205)		egg1(canvas, screen,5);
	if(screen.screenNum == 146)		egg1(canvas, screen,6);
	if(screen.screenNum == 149)		egg1(canvas, screen,7);
	if(screen.screenNum == 152)		egg1(canvas, screen,8);
	if(screen.screenNum == 155)		egg1(canvas, screen,9);
	if(screen.screenNum == 158)		egg1(canvas, screen,10);
	if(screen.screenNum == 127)		egg1(canvas, screen,11);
	if(screen.screenNum == 125)		egg1(canvas, screen,12);
	if(screen.screenNum == 123)		egg1(canvas, screen,13);
	if(screen.screenNum == 121)		egg1(canvas, screen,14);
	if(screen.screenNum == 119)		egg1(canvas, screen,15);


}

//TODO make other 14 eggs.
function egg1(canvas, screen,num){
	canvas.click(function(){
		processEgg(num);
	})
}

//janus is a bad listener.
function talkJanus(){
	if(janusNum == 0) console.log("Janus1: It's about time you found me. Harumph.  Talk back by typing: 'talkJanus('thing you want to say in quotes')'.  Now, do you want the Solution?");
	if(janusNum == 1) console.log("Janus1: Of course you do. Kids these days have no respect for artistry. Do you know how HARD it was to come up with that puzzle? Don't answer that. If you want the Solution, then you will have to give me a Solution of your own. I'm sure you noticed how the control panel lit up.  That's what got my attention.  I can't figure out how to get all the control panel symbols lit up.  Do this for me, and I will show you how to beat the puzzle.");
	if(janusNum > 1 && !eggsSolution) console.log("Janus1: Consarn it! Would you leave me alone if you haven't got my Solution yet?")
	if(janusNum > 1 && eggsSolution){
		console.log("Janus1: Well hot damn! You did it! Gives me hope for the next generation, is what it does. ")
		console.log("Janus2:  If you had even attempted to think about the puzzle yourself, dear brother, you would have found the solution to be obvious. ")
		console.log("Janus2:  And now it falls to me to honor the promises you have kept, in your haste to prove your ignorance. ")
		console.log("Janus1: Well ain't you a breath of fresh air! I haven't heard you talk in a DOG's age!")
		console.log("Janus2:  *sigh* I will give you your Solution, Observer, that you may marvel in the mind that TRULY designed this Challenge. ")
		//TODO have puzzle auto-solve itself.
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

//on first egg, ALSO unlock jr.
//rest of eggs cause glow on panel.  get all eggs....secret???
function processEgg(num){
	if(janusNum == 0) janus();
	eggs[num] = "found it!";
	console.log("TODO: change src for appropriate image.")
	for(var i = 1; i<=15; i++){
		if(eggs[i] != "found it!")  return;
	}
	console.log("ANNOUNCMENT: ALL EGGS FOUND!")
	eggsSolution = true;
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
		var ctx = canvas.getContext('2d');
		var x = this.width/2;
		//var x = 0;
		var y = this.height/2;
		ctx.fillStyle = "#000000";
		ctx.fillText(this.state,x,y);
		x += 1;
		y += 1;
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
