/* fix l8r

//simple code that allows you to browser hair/horns or fanart.
window.onload = () {
	loadNavbar();
	if (getParameterByName("hair")  == "true"){
		querySelector("#header").html("Hair Gallery");
		renderAllHair();
	}
	if (getParameterByName("horns")  == "true"){
		renderAllHorns();
		querySelector("#header").html("Horn Gallery");
	}
	if (getParameterByName("grimAB")  == "true"){
		querySelector("#header").html("GrimDark AB Gallery");
		renderFanArtGrimAB();
	}

	if (getParameterByName("firstPlayer")  == "true"){
    		$("#header").html("First Player Post Great Refactoring Gallery");
    		renderFirstPlayerFanArt();
    }

	if (getParameterByName("stareyes")  == "true"){
		querySelector("#header").html("star.eyes memes");
		renderFanArtStarEyes();
	}

	if (getParameterByName("gifs")  == "true"){
		querySelector("#header").html("Gif Gallery");
		renderFanArtGifs();
	}

	if(getParameterByName("fanArt")  == "true"){
		renderFanArtGrimAB();
		renderFanArtStarEyes();
		renderFanArtGifs();
		querySelector("#header").html("FanArt Gallery");
	}
}

//don't hard code fan art, instead, scrape all files of .png or .jpg or .gif or .jpeg out of a given folder and render.
void renderFanArtGrimAB(){
	//String folder = "images/misc/fanArt/ABFanArt/";
	String folder = "http:;//farragofiction.com/SBURBSimE/images/misc/fanArt/ABFanArt/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}

void renderFirstPlayerFanArt(){
	String folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/FirstPlayer/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.

}


//don't hard code fan art, instead, scrape all files of .png or .jpg or .gif or .jpeg out of a given folder and render.
void renderFanArtStarEyes(){
	//String folder = "images/misc/fanArt/ABFanArt/";
	String folder = "http:;//farragofiction.com/SBURBSimE/images/misc/fanArt/star.eyes/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}



//don't hard code fan art, instead, scrape all files of .png or .jpg or .gif or .jpeg out of a given folder and render.
void renderFanArtGifs(){
	String folder = "http:;//farragofiction.com/SBURBSimE/images/misc/fanArt/gifs/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}





//use ajax to get index file, then do yo thang.
//https://stackoverflow.com/questions/22061073/how-do-i-get-images-file-name-from-a-given-folder
class renderAllImagesInFolder {

	renderAllImagesInFolder(this.folder) {}



	print("tring to get folder: " + folder);
	var fileExt = {};
    fileExt[0]=".png";
    fileExt[1]=".jpg";
    fileExt[2]=".gif";
		fileExt[3]=".jpeg";
		$.ajax({
			//This will retrieve the contents of the folder if the folder is configured as 'browsable'
			url: folder,
			success: (data) {
			   //List all png or jpg or gif file names in the page
			   querySelector(data).find("a:contains(" + fileExt[0] + "),a:contains(" + fileExt[1] + "),a:contains(" + fileExt[2] + ")").each(() {
				  var split = this.href.split("/");
					var filename = split[split.length-1];
					print("found: " + filename);
					//var filename = this.href;
				   renderRegularSprite(new SpritePart(folder+filename, filename));
			   });
			 }

		  });
}



void renderRegularSprite(spritePart){
	querySelector("#images").append("<div class = 'spriteParentNoSize'><img class = 'spriteImgNoLayers' src = '" + spritePart.location + "'></img><br>"+spritePart.name+"</div>");
}




void renderAllHair(){
	num minHair = 1;
	var blankPlayer = new Player();
	var maxHair = blankPlayer.maxHairNumber;
	//don't use canvas, but still layer?  bg, like for KR.
	for(var i = minHair; i<= maxHair; i++){
			renderLayeredSprites([new SpritePart("images/Hair/hair_back"+i+".png", "Hair " +i),new SpritePart("images/Hair/head.png", ""), new SpritePart("images/Hair/hair"+i+".png", "")]);
	}
}



void renderAllHorns(){
	num minHorn = 1;
	var blankPlayer = new Player();
	var maxHorn = blankPlayer.maxHornNumber;
	for(var i = minHorn; i<= maxHorn; i++){
			renderLayeredSprites([new SpritePart("images/Horns/left"+i+".png","leftHorn "+i),new SpritePart("images/Horns/right"+i+".png", "rightHorn" +i)]);
	}
}



//first thing on bottom, last thing on top
void renderLayeredSprites(spriteArray){
	String html = "<div class = 'spriteParent'>"; //all images should be rendered at same position in sprite parent
	for(num i = 0; i<spriteArray.length; i++){
		html += "<img class = 'spriteImg' src = '" + spriteArray[i].location + "'></img><br>"+spriteArray[i].name;
	}
	html += "</div>";
	querySelector("#images").append(html);
}




class SpritePart {

	SpritePart(this.location, this.name) {}



	var location;
	var name;}
*/