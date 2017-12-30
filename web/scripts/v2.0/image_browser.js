//simple code that allows you to browser hair/horns or fanart.
window.onload = function() {
	loadNavbar();
	if (getParameterByName("hair")  == "true"){
		$("#header").html("Hair Gallery");
		renderAllHair();
	}
	if (getParameterByName("horns")  == "true"){
		renderAllHorns();
		$("#header").html("Horn Gallery");
	}
	if (getParameterByName("grimAB")  == "true"){
		$("#header").html("GrimDark AB Gallery");
		renderFanArtGrimAB();
	}

	if (getParameterByName("mascotCompetition")  == "true"){
    		$("#header").html("Shogun vs JR: <a href = 'https://drive.google.com/drive/folders/1dUSRkaW4zZD6r21gywPvR_YHcL7gvzUn?usp=sharing'>https://drive.google.com/drive/folders/1dUSRkaW4zZD6r21gywPvR_YHcL7gvzUn?usp=sharing PUT YOUR NAME IN THE FILE NAME SO WE KNOW WHO MADE IT</a>");
    		renderMascotCompetition();
    	}

	if (getParameterByName("octobermas")  == "true"){
    		$("#header").html("Octobermas");
    		octobermas();
    }

    if (getParameterByName("shogunsim")  == "true"){
        		$("#header").html("ShogunSim");
        		shogunsim();
        }

    if (getParameterByName("oblivionSurfer")  == "true"){
        		$("#header").html("oblivionSurfer");
        		oblivionSurfer();
        }

	if (getParameterByName("firstPlayer")  == "true"){
    		$("#header").html("First Player Post Great Refactoring Gallery");
    		renderFirstPlayerFanArt();
    }

	if (getParameterByName("stareyes")  == "true"){
		$("#header").html("star.eyes memes");
		renderFanArtStarEyes();
	}

	if (getParameterByName("gifs")  == "true"){
		$("#header").html("Gif Gallery");
		renderFanArtGifs();
	}

	if (getParameterByName("misc")  == "true"){
    		$("#header").html("Misc Art");
    		renderFanArtMisc();
    	}

	if(getParameterByName("fanArt")  == "true"){
		renderFanArtGrimAB();
		renderFanArtStarEyes();
		renderFanArtGifs();
		renderFanArtMisc();
		$("#header").html("FanArt Gallery");
	}
}
function renderFirstPlayerFanArt(){
//var folder = "images/misc/fanArt/ABFanArt/"
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/FirstPlayer/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}

function oblivionSurfer(){
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/oblivionSurfer/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}

function shogunsim(){
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/ShogunSim/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.

}

function renderMascotCompetition(){
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/MascotCompetition/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.

}

function octobermas(){
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/OctoberMas/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.

}
//don't hard code fan art, instead, scrape all files of .png or .jpg or .gif or .jpeg out of a given folder and render.
function renderFanArtGrimAB(){
	//var folder = "images/misc/fanArt/ABFanArt/"
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/ABFanArt/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}

//don't hard code fan art, instead, scrape all files of .png or .jpg or .gif or .jpeg out of a given folder and render.
function renderFanArtStarEyes(){
	//var folder = "images/misc/fanArt/ABFanArt/"
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/star.eyes/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}

//don't hard code fan art, instead, scrape all files of .png or .jpg or .gif or .jpeg out of a given folder and render.
function renderFanArtGifs(){
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/gifs/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}

//don't hard code fan art, instead, scrape all files of .png or .jpg or .gif or .jpeg out of a given folder and render.
function renderFanArtMisc(){
	var folder = "http://farragofiction.com/SBURBSimE/images/misc/fanArt/miscFanArt/";
	renderAllImagesInFolder(folder); //if can't scrape from local computer, make this an absolute reference to server.  haha, no i can't cross session scripting is a bitch. HAVE to test on server l8r.
}


//use ajax to get index file, then do yo thang.
//https://stackoverflow.com/questions/22061073/how-do-i-get-images-file-name-from-a-given-folder
function renderAllImagesInFolder(folder){
	console.log("tring to get folder: " + folder)
	var fileExt = {};
    fileExt[0]=".png";
    fileExt[1]=".jpg";
    fileExt[2]=".gif";
		fileExt[3]=".jpeg";
		$.ajax({
			//This will retrieve the contents of the folder if the folder is configured as 'browsable'
			url: folder,
			success: function (data) {
			   //List all png or jpg or gif file names in the page
			   $(data).find("a:contains(" + fileExt[0] + "),a:contains(" + fileExt[1] + "),a:contains(" + fileExt[2] + ")").each(function () {
				  var split = this.href.split("/")
					var filename =  split[split.length-1];
					console.log("found: " + filename);
					//var filename = this.href;
				   renderRegularSprite(new SpritePart(folder+filename, filename));
			   });
			 }

		  });
}

function renderRegularSprite(spritePart){
	$("#images").append("<div class = 'spriteParentNoSize'><a href = '" + spritePart.location + "'><img width = '250' class = 'spriteImgNoLayers' src = '" + spritePart.location + "'></img></a><br>"+spritePart.name+"</div>");
}


function renderAllHair(){
	var minHair = 1;
	var maxHair = 74;
	//don't use canvas, but still layer?  bg, like for KR.
	for(var i = minHair; i<= maxHair; i++){
			renderLayeredSprites([new SpritePart("images/Hair/hair_back"+i+".png", "Hair " +i),new SpritePart("images/Hair/head.png", ""), new SpritePart("images/Hair/hair"+i+".png", "")]);
	}
}

function renderAllHorns(){
	var minHorn = 1
	var maxHorn = 73;
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
