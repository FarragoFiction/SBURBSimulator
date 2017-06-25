var screens = [];
var maxState = 38;
//figure out a number of turns until the reckoning. make it more than you'd reasonably need to solve it
//so only if they get distracted does it turn deadly.
//each image you unlock has jr make a comment on the image, and gives you a hint about how to
//get to the denizen to have the puzzle just solved for you. (for a price)

window.onload = function() {
	makeScreens(256);

	//only load images via code while developing. want them hardcoded in the initial
	//loadImages(maxState);
	//eventually call makeDistactions AFTER the user clicks "start". because i want to wait for the images to load without bothering with loading code.

	//throw makeDistactions into a timeout so it's asynch, but don't let things 'start' till it's done.
	makeDistactions(maxState);
	renderLoop();
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
			var uY = Math.round(i/16 * 45);
			screens.push(new Screen(document.getElementById("screen"+i),maxState, uX, uY));
		}
}

function loadImages(lastImage){
	var html = "";
	for(var i = 0; i<= lastImage; i++){
		html += "<img id = 'distaction"+i+"'style = 'display:none;' src = 'images/LORAS/" + i + ".png'>"
	}
	$("#loading_image_staging").append(html);

}

function makeDistactions(lastImage){
	for(var i = 0; i<= 1; i++){
		makeDistactionChunks(i,"distaction"+i, screens)
	}
}



function Screen(canvas,maxState, uX, uY){
	this.canvas = canvas;
	this.maxState = maxState;
	this.state = 0;
	this.upperLeftX = uX;
	this.upperLeftY = uY;
	this.size = 45; //<-- don't fucking change this.
	this.distactions = []; //just an array of image data.

	this.changeState = function(state){
		if(state < 0){
			state = 0;
		} else if(state > this.maxState){
			state = maxState;
		}else{
			this.state = state;
		}
		display();
	}

	this.display = function(){
			console.log("diaply");
		  var ctx = canvas.getContext('2d');
		  ctx.putImageData(this.distactions[this.state], 0, 0);
	}
}


function makeDistactionChunks(id, imageDiv, screens){
	for(var i = 0; i<screens.length; i++){
		makeDistactionChunk(id, imageDiv, screens[i]);
	}
}

function makeDistactionChunk(id, imageDiv, screen){
		//console.log("Making a chunk")
		//draw to secret canvas, then var pixels =ctx.getImageData(0, 0, canvas.width, canvas.height);
		var canvas = getTemporaryCanvas();
		var ctx = canvas.getContext('2d');
		var img=document.getElementById(imageDiv);
		var width = img.width;
		var height = img.height;
		ctx.drawImage(img,0,0,width,height);
		//might be faster to call getImageData once and then write code to chunk it up, rather than calling it 256 times for each image.
		screen.distactions.push(ctx.getImageData(screen.upperLeftX, screen.upperLeftY, screen.size, screen.size));

}


function getTemporaryCanvas(){
	var tmp_canvas = document.createElement('canvas');
	tmp_canvas.height = 720;
	tmp_canvas.width = 720;
	return tmp_canvas;
}
