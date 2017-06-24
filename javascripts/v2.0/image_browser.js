//simple code that allows you to browser hair/horns or fanart.
window.onload = function() {
	loadNavbar();
	if (getParameterByName("hair")  == "true") renderAllHair();
	if (getParameterByName("horns")  == "true") renderAllHorns();
	if (getParameterByName("grimAB")  == "true") renderFanArtGrimAB();
}

//don't hard code fan art, instead, scrape all files of .png or .jpg or .gif or .jpeg out of a given folder and render.
function renderFanArtGrimAB(){
	//var folder = "images/misc/fanArt/ABFanArt/"
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/ABFanArt/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}

//use ajax to get index file, then do yo thang.
//https://stackoverflow.com/questions/22061073/how-do-i-get-images-file-name-from-a-given-folder
function renderAllImagesInFolder(folder){
	var fileExt = {};
    fileExt[0]=".png";
    fileExt[1]=".jpg";
    fileExt[2]=".gif";
	fileExt[2]=".jpeg";
		$.ajax({
			//This will retrieve the contents of the folder if the folder is configured as 'browsable'
			url: folder,
			success: function (data) {
			   //List all png or jpg or gif file names in the page
			   $(data).find("a:contains(" + fileExt[0] + "),a:contains(" + fileExt[1] + "),a:contains(" + fileExt[2] + ")").each(function () {
				  var split = this.href.split("/")
					var filename =  split[split.length-1];
					//var filename = this.href;
				   renderRegularSprite(new SpritePart(folder+filename, filename));
			   });
			 }

		  });
}

function renderRegularSprite(spritePart){
	$("#images").append("<img class = 'spriteImg' src = '" + spritePart.location + "'></img><br>"+spritePart.name);
}


function renderAllHair(){
	var minHair = 1;
	var blankPlayer = new Player();
	var maxHair = blankPlayer.maxHairNumber
	//don't use canvas, but still layer?  bg, like for KR.
	for(var i = minHair; i<= maxHair; i++){
			renderLayeredSprites([new SpritePart("images/Hair/hair_back"+i+".png", "Hair " +i),new SpritePart("images/Hair/head.png", ""), new SpritePart("images/Hair/hair"+i+".png", "")]);
	}
}

function renderAllHorns(){
	var minHorn = 1
	var blankPlayer = new Player();
	var maxHorn = blankPlayer.maxHornNumber
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
