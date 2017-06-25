var screens = [];
var maxState = 53;
var imagesWaiting = 0;
var imagesLoaded = 0;
var targetImage = 0; //what could control this???
var x = [];

var distactions = new Array(maxState); //all images, screen responsible for displaying it's chunk
//figure out a number of turns until the reckoning. make it more than you'd reasonably need to solve it
//so only if they get distracted does it turn deadly.
//each image you unlock has jr make a comment on the image, and gives you a hint about how to
//get to the denizen to have the puzzle just solved for you. (for a price)

window.onload = function() {
	initializeX();
	makeScreens(256);
	loadAllImages();
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
	compute(0,ia);
}

//k = 0
function button2(){
	compute(0,fhtagn);
}


// k = 1
function button3(){
	compute(1,ia);
}

//k = 1
function button4(){
	compute(1,fhtagn);
}

//k = 2
function button5(){
	compute(2,ia);
}

//k = 2
function button6(){
	compute(2,fhtagn);
}

function ia(k){
/*
N'[k] = n[k]/2

and punish if n[k] was not even.
*/
}

function fhtagn(k){
		/*
then N'[k] = n[k]*3 +1
*/
}

function calculateN(){
	//N[k] = 1 + sum(  y[k][i]*(q**i) for i in range(3))
}

function compute(k, formula){
	var q = maxState;
	var yk = new Array(3);
	for(var i = 0; i<yk.length; i++){
		yk[i] = (x[k][i] - targetImage + q) % q
	}

	var n = calculateN(k, yk);
		/*

	N[k] = 1 + sum(  y[k][i]*(q**i) for i in range(3))
	*/
	formula();
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
	canvas.click(function(){
		console.log(screen.upperLeftX)
		screen.randomizeState();
	})
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
		console.log(state);
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
		//var x = this.width/2;
		var x = 0;
		var y = this.height/2;
		ctx.fillStyle = "#000000";
		ctx.fillText(this.state,x,y);
		x += 1;
		y += 1;
		ctx.fillStyle = "#ffffff";
		console.log(this.k)
		//ctx.fillText(this.state + "<"+this.i+",x,y);
		ctx.fillText(this.state + "<"+this.i+"," +this.k+">",x,y);
	}

	this.display = function(){
		console.log("display: " + this.state);
		this.clearSelf();
	  var ctx = canvas.getContext('2d');
		var image = distactions[this.state];
		console.log(image);
		ctx.drawImage(image, this.upperLeftX, this.upperLeftY, this.width, this.height, 0, 0, this.width, this.height);
		this.drawState();
	}
}
