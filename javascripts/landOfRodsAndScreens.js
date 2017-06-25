var screens = [];
var distactions = [];
//figure out a number of turns until the reckoning. make it more than you'd reasonably need to solve it
//so only if they get distracted does it turn deadly.
//each image you unlock has jr make a comment on the image, and gives you a hint about how to
//get to the denizen to have the puzzle just solved for you. (for a price)

window.onload = function() {
	makeScreens(256);
	loadImages(38);
	//eventually call makeDistactions AFTER the user clicks "start". because i want to wait for the images to load without bothering with loading code.
	makeDistactions(38);
}

//css will handle putting them into a grid, don't worry about it.
function makeScreens(number){
		for(var i = 0; i< number; i++){
			var html = "<canvas class = 'screen' id = 'screen" + i + "' width = '45' height = '45'></canvas>";
			$("#landScreens").append(html);
			screens.push(new Screen(document.getElementById("screen"+i)));
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
	for(var i = 0; i<= lastImage; i++){
		distactions.push(new Distaction(i,"distaction"+i))
	}
}



function Screen(canvas){
	this.canvas = canvas;
	this.state = 0;
}

//raw pixels needed to render this distaction in it's entirety
//if you pass it a screen ID it will return what pixels that screen can render
//it is is a distaction, you see, because the 'goal' is to get to state 0
//and all of these will want you to NOT do that.
function Distaction(id, imageDiv){
	this.id = id; //which image am i
	this.image_data = null;

	this.processImageDiv = function(imageDivID){
		//draw to secret canvas, then var pixels =ctx.getImageData(0, 0, canvas.width, canvas.height);
		var canvas = this.getTemporaryCanvas();
		var ctx = canvas.getContext('2d');
		var img=document.getElementById(imageDivID);
		var width = img.width;
		var height = img.height;
		ctx.drawImage(img,0,0,width,height);
		return ctx.getImageData(0, 0, canvas.width, canvas.height);
	}

	this.getTemporaryCanvas = function(){
		var tmp_canvas = document.createElement('canvas');
		tmp_canvas.height = 720;
		tmp_canvas.width = 720;
		return tmp_canvas;
	}

	this.image_data = this.processImageDiv(imageDiv);
}
