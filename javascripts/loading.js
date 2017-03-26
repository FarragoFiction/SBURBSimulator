var imagesWaiting = 0;
var imagesLoaded = 0;

//load everything while showing a progress bar. delete loadingCanvas when done.
function load(players, guardians){
  var canvas = document.getElementById("loading");
  var ctx = canvas.getContext('2d');
  var imageString = "loading.png";
  var img=document.getElementById(imageString);
  var width = img.width;
  var height = img.height;
  ctx.drawImage(img,0,0,width,height);
	loadAllImages(players, guardians);
}

function loadAllImages(players, guardians){
	var numImages = 0;
	//same number of players and guardians
	for(var i = 0; i<players.length; i++){
		loadPlayer(players[i]);
	}
	//guardians aren't going to match players if combo session
	for(var i = 0; i<guardians.length; i++){
		loadPlayer(guardians[i]);
	}

	loadOther(players, guardians);

}



function addImageTagLoading(url){
  //console.log(url);
	//only do it if image hasn't already been added.
	if(document.getElementById(url) == null) {
		var tag = '<img id ="' + url + '" src = "images/' + url + '" style="display:none">';
		$("#loading_image_staging").append(tag);
	}

}

function checkDone(){
	if(imagesLoaded != 0 && imagesWaiting == imagesLoaded){
		//$("#loading").remove(); //not loading anymore
		intro();
	}
}

function loadImage(img){
	imagesWaiting ++;
	var imageObj = new Image();
  imageObj.onload = function() {
      //  context.drawImage(imageObj, 69, 50); //i don't want to draw it. i could put it in image staging?
			addImageTagLoading(img);
			imagesLoaded ++;
			checkDone();
  };

  imageObj.onerror = function(){
    debug("Error loading image: " + this.src)
    //alert(this.src)
  }
      imageObj.src = "images/"+img;
}

//load pesterchum, blood, big aspect symbols, echeladders, god tier level up, romance symbols, babies, grubs
function loadOther(){
	loadImage("jr.png");
  loadImage("gears.png");
  loadImage("mind_forehead.png")
	loadImage("ab.png")
	loadImage("grimdark.png");
	loadImage("fin1.png");
	loadImage("fin2.png");
	loadImage("echeladder.png")
	loadImage("godtierlevelup.png");
	loadImage("pesterchum.png");
	loadImage("blood_puddle.png")
	loadImage("scratch_face.png")
	loadImage( "Prospit.png")
	loadImage("Prospit_symbol.png");
	loadImage("Derse.png")
	loadImage("Derse_symbol.png");
	loadImage("bloody_face.png")
	loadImage("Moirail.png")
	loadImage("Matesprit.png")
	loadImage("Auspisticism.png")
	loadImage("Kismesis.png")
	loadImage("prince_hat.png")
  loadImage("discuss_romance.png")
  loadImage("discuss_hatemance.png")
  loadImage("discuss_sburb.png")
  loadImage("discuss_jack.png")
  loadImage("discuss_murder.png")
	for(var i = 1; i<4; i++){
		loadImage("Bodies/baby"+i + ".png")
	}

	for(var i = 1; i<4; i++){
		loadImage("Bodies/grub"+i + ".png")
	}
}

//load hair, horns, wings, regular sprite, god sprite, fins, aspect symbol, moon symbol for each player
function loadPlayer(player){
	//var imageString = "Horns/right"+player.rightHorn + ".png";
  //addImageTag(imageString)
	loadImage(playerToRegularBody(player));
	loadImage(playerToGodBody(player));
	loadImage(player.aspect + ".png");

	loadImage(player.aspect + "Big.png")
	loadImage("Hair/hair"+player.hair+".png")
  loadImage("Hair/hair_back"+player.hair+".png")

	if(player.isTroll == true){
		loadImage("Wings/wing"+player.quirk.favoriteNumber + ".png")
		loadImage("Horns/left"+player.leftHorn + ".png");
		loadImage("Horns/right"+player.rightHorn + ".png");
		//loadImage("Bodies/grub"+player.baby + ".png")
	}else{
		//loadImage("Bodies/baby"+player.baby + ".png")
	}
}
