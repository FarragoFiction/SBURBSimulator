var imagesWaiting = 0;
var imagesLoaded = 0;

//load everything while showing a progress bar. delete loadingCanvas when done.
function load(players, guardians,skipInit){
  var guardians = getGuardiansForPlayers(players)
  var canvas = document.getElementById("loading");
  var ctx = canvas.getContext('2d');
  var imageString = "loading.png";
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
	loadAllImages(players, guardians,skipInit);
}

function loadAllImages(players, guardians,skipInit){
	var numImages = 0;
	//same number of players and guardians
	for(var i = 0; i<players.length; i++){
		loadPlayer(players[i],skipInit);
	}
	//guardians aren't going to match players if combo session
	for(var i = 0; i<guardians.length; i++){
		loadPlayer(guardians[i],skipInit);
	}

	loadOther(skipInit);

}



function addImageTagLoading(url){
  //console.log(url);
	//only do it if image hasn't already been added.
	if(document.getElementById(url) == null) {
		var tag = '<img id ="' + url + '" src = "images/' + url + '" style="display:none">';
		$("#loading_image_staging").append(tag);
	}

}

function checkDone(skipInit){
	if(imagesLoaded != 0 && imagesWaiting == imagesLoaded){
		//$("#loading").remove(); //not loading anymore
    if(skipInit){
      renderPlayersForEditing();
      return;
    }
		intro();
	}
}

function loadImage(img,skipInit){
	imagesWaiting ++;
	var imageObj = new Image();
  imageObj.onload = function() {
      //  context.drawImage(imageObj, 69, 50); //i don't want to draw it. i could put it in image staging?
			addImageTagLoading(img);
			imagesLoaded ++;
			checkDone(skipInit);
  };

  imageObj.onerror = function(){
    debug("Error loading image: " + this.src)
    //alert(this.src)
  }
      imageObj.src = "images/"+img;
}

//load pesterchum, blood, big aspect symbols, echeladders, god tier level up, romance symbols, babies, grubs
function loadOther(skipInit){
	loadImage("jr.png",skipInit);
	loadImage("stab.png",skipInit);
  loadImage("denizoned.png",skipInit);
  loadImage("sceptre.png",skipInit);
	loadImage("rainbow.png",skipInit);
	loadImage("gears.png",skipInit);
	loadImage("mind_forehead.png",skipInit)
	loadImage("ab.png",skipInit)
	loadImage("grimdark.png",skipInit);
  loadImage("squiddles_chaos.png",skipInit);
	loadImage("fin1.png",skipInit);
	loadImage("fin2.png",skipInit);
	loadImage("echeladder.png",skipInit)
	loadImage("godtierlevelup.png",skipInit);
	loadImage("pesterchum.png",skipInit);
	loadImage("blood_puddle.png",skipInit)
	loadImage("scratch_face.png",skipInit)
	loadImage("robo_face.png",skipInit)
	loadImage("calm_scratch_face.png",skipInit)
	loadImage( "Prospit.png",skipInit)
	//loadImage("Prospit_symbol.png");
	loadImage("Derse.png",skipInit)
	//loadImage("Derse_symbol.png");
	loadImage("bloody_face.png",skipInit)
	loadImage("Moirail.png",skipInit)
	loadImage("Matesprit.png",skipInit)
	loadImage("Auspisticism.png",skipInit)
	loadImage("Kismesis.png",skipInit)
	loadImage("prince_hat.png",skipInit)
	loadImage("discuss_romance.png",skipInit)
	loadImage("discuss_hatemance.png",skipInit)
	loadImage("discuss_breakup.png",skipInit)
	loadImage("discuss_sburb.png",skipInit)
	loadImage("discuss_jack.png",skipInit)
	loadImage("discuss_murder.png",skipInit)
  loadImage("discuss_raps.png",skipInit)
	for(var i = 1; i<4; i++){
		loadImage("Bodies/baby"+i + ".png",skipInit)
	}

	for(var i = 1; i<4; i++){
		loadImage("Bodies/grub"+i + ".png",skipInit)
	}
}

//load hair, horns, wings, regular sprite, god sprite, fins, aspect symbol, moon symbol for each player
function loadPlayer(player,skipInit){
	//var imageString = "Horns/right"+player.rightHorn + ".png";
  //addImageTag(imageString)
	loadImage(playerToRegularBody(player),skipInit);
  loadImage(playerToDreamBody(player),skipInit);
	loadImage(playerToGodBody(player),skipInit);
	loadImage(player.aspect + ".png",skipInit);

	loadImage(player.aspect + "Big.png",skipInit)
	loadImage("Hair/hair"+player.hair+".png",skipInit)
  loadImage("Hair/hair_back"+player.hair+".png",skipInit)

	if(player.isTroll == true){
		loadImage("Wings/wing"+player.quirk.favoriteNumber + ".png",skipInit)
		loadImage("Horns/left"+player.leftHorn + ".png",skipInit);
		loadImage("Horns/right"+player.rightHorn + ".png",skipInit);
		//loadImage("Bodies/grub"+player.baby + ".png")
	}else{
		//loadImage("Bodies/baby"+player.baby + ".png")
	}
}
