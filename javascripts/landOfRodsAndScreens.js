var screens = [];
var maxState = 38;
var distactions = []; //all images, screen responsible for displaying it's chunk
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
	getAllImages(maxState)
	renderLoop();
}

function getAllImages(maxState){
	for(var i = 0; i< 2; i++){
		distactions.push(document.getElementById("distaction"+i))
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
		//the below WORKS but is slow as balls
		//makeDistactionChunks(i,"distaction"+i, screens)
		//while the two methods below do NOT work and make me want to eat a bear. what the hell man.
		//claims to be rendering, but it's blank. i can SEE that the imageData has shit in it.
		//imgData = makeWholeDistaction(i,"distaction"+i);
		//distactions.push(makeWholeDistaction(i,"distaction"+i))
		//processImgDataForScreens(imgData.data,screens);

	}
}

//for each screen, chops up the image Data into chunks.
function processImgDataForScreens(imgData, screens){
	for(var i = 0; i<screens.length; i++){
		screens[i].distactions.push(screens[i].getChunk(imgData,720,720))
	}
}




function makeDistactionChunks(id, imageDiv, screens){
	for(var i = 0; i<screens.length; i++){
		makeDistactionChunk(id, imageDiv, screens[i]);
	}
}

//is this faster than doing getImageData 256 times for each image?
function makeWholeDistaction(id, imageDiv){
	var canvas = getTemporaryCanvas();
	var ctx = canvas.getContext('2d');
	var img=document.getElementById(imageDiv);
	var width = img.width;
	var height = img.height;
	ctx.drawImage(img,0,0,width,height);
	return ctx.getImageData(0, 0, width, height);
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
		//bluh, my brain hates treating arrays like matrices.
		screen.distactions.push(ctx.getImageData(screen.upperLeftX, screen.upperLeftY, screen.width, screen.height));
}


function getTemporaryCanvas(){
	var tmp_canvas = document.createElement('canvas');
	tmp_canvas.height = 720;
	tmp_canvas.width = 720;
	return tmp_canvas;
}


function Screen(canvas,maxState, uX, uY, screenNum){
	this.canvas = canvas;
	this.maxState = maxState;
	this.state = 0;
	this.screenNum = screenNum;
	this.upperLeftX = uX;
	this.upperLeftY = uY;
	this.height = 45; //<-- don't fucking change this.
	this.width = 45;
	this.distactions = []; //just an array of image data.

	//imgData is an array, need to review the math to get a chunk of that array.
	//want upperLeftx, upperLeftY for this.size pixels.
	this.getChunk = function(imgData, imgWidth, imgHeight){
		 var ctx = canvas.getContext('2d');
		//a chunk is chunk-height slices of the array, with each slice being chunk-width long.
		//the START of each slice is the complicated bit.
		//think about it.
		var ret = new Uint8ClampedArray(this.width * this.height*4);
		//one loop for each slice i'll need.
		for(var i = 0; i<this.height*4; i++){
			var start = this.getChunkFirstPixel(imgWidth*4, imgHeight*4) * (imgWidth *i) * 4;
			var slice = (imgData.slice(start, start + this.width*4));
			for(var j = 0; j<slice.length; j++){
				ret[j*i] =slice[j]
			}
		}

		imgData = ctx.createImageData(this.width,this.height);
		for(var i = 0; i<this.width*this.height*4; i+=4){
			if(i < ret.length){
				imgData.data[i] = ret[i];
				imgData.data[i+1] = ret[i+1];
				imgData.data[i+2] = ret[i+2];
				imgData.data[i+3] = ret[i+3];
			}else{
				console.log('blank ' + "i: " + i + "ret:" + ret.length)
				imgData.data[i]= 0;
				imgData.data[i+1]= 0;
				imgData.data[i+2]= 0;
				imgData.data[i+3]= 0;
			}

		}
		//might have to convert ret to Uint8ClampedArray first.
		console.log("returning" + imgData)
		return imgData;
	}

	this.getChunkFirstPixel = function(imgWidth, imgHeight){
		return 0;  //TODO figure out the math.
	}

	this.changeState = function(state){
		if(state < 0){
			state = 0;
		} else if(state > this.maxState){
			state = maxState;
		}else{
			this.state = state;
		}
		this.display();
	}

	this.display = function(){
			console.log("diaply");
		  var ctx = canvas.getContext('2d');
			/*var data = this.distactions[this.state]
			console.log(canvas)
			console.log(data)
		  ctx.putImageData(data, 0, 0);
			*/
			//ctx.putImageData(distactions[this.state],this.upperLeftX, this.upperLeftY, this.width, this.height)
			var image = distactions[this.state];

			ctx.drawImage(image, this.upperLeftX, this.upperLeftY, this.width, this.height, 0, 0, this.width, this.height);
	}
}
