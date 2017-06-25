var screens = [];
window.onload = function() {
	//first, create the 16 x 16 matrix of canvases.
	makeScreens(256);
}

function makeScreens(number){
		for(var i = 0; i< number; i++){
			var html = "<canvas class = 'screen' id = 'screen" + i + "' width = '62' height = '62'></canvas>";
			$("#landScreens").append(html);
			screens.push(new Screen(document.getElementById("screen"+i)));
		}
}

function Screen(canvas){
	this.canvas = canvas;
}

//raw pixels needed to render this distaction in it's entirety
function Distaction(id, image_data){
	this.id = id;
	this.image_data = image_data
}
