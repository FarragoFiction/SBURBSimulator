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
			renderLayeredSprites([new SpritePart("images/Hair/hair_back"+i+".png", "Hair " +i),new SpritePart("images/Hair/hair"+i+".png", "")]);
	}
}

function renderAllHorns(){
	var minHorn = 1
	var maxHorn = 53;
	for(var i = minHorn; i<= maxHorn; i++){
			renderLayeredSprites([new SpritePart("images/Horns/left"+i+".png","leftHorn "+i),new SpritePart("images/Horns/right"+i+".png", "rightHorn" +i)]);
	}
}

//first thing on bottom, last thing on top
function renderLayeredSprites(spriteArray){
	var html = "<div class = 'spriteParent'>"; //all images should be rendered at same position in sprite parent
	for(var i = 0; i<spriteArray.length; i++){
		html += "<img class = 'spriteImg' src = '" + spriteArray[i].location + "'></img><br>"+spriteArray[i].name;
	}
	html += "</div>"
	$("#images").append(html);
}


function SpritePart(location, name){
	this.location = location;
	this.name = name;
}
