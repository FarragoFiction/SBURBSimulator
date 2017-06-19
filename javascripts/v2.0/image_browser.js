//simple code that allows you to browser hair/horns or fanart.
window.onload = function() {
	loadNavbar();
	if (getParameterByName("hair")  == "true") renderAllHair();
	if (getParameterByName("horns")  == "true") renderAllHorns();
}




function renderAllHair(){
	var minHair = 1;
	var maxHair = 60;
	//don't use canvas, but still layer?  bg, like for KR.
	for(var i = minHair; i<= maxHair; i++){
			renderLayeredSprites(["images/Hair/hair_back"+i+".png","images/Hair/hair"+i+".png"]);
	}
}

function renderAllHorns(){
	var minHorn = 1
	var maxHorn = 60;
	for(var i = minHorn; i<= maxHorn; i++){
			renderLayeredSprites(["images/Horns/left"+i+".png","images/Horns/right"+i+".png"]);
	}
}

//first thing on bottom, last thing on top
function renderLayeredSprites(spriteArray){
	var html = "<div class = 'spriteParent'>"; //all images should be rendered at same position in sprite parent
	for(var i = 0; i<spriteArray.length; i++){
		html += "<img class = 'spriteImg' src = '" + spriteArray[i] + "'></img>";
	}
	html += "</div>"
	$("#images").append(html);
}
