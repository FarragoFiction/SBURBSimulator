import "dart:html";

import "SBURBSim.dart";

num imagesWaiting = 0;
num imagesLoaded = 0;
var callBack = null;

dynamic loadFuckingEverything(String skipInit, cb){
	if(doNotRender == true) return checkDone(skipInit);
	loadAllImages(skipInit);
	callBack = cb;
	return null;
}





//load everything while showing a progress bar. delete loadingCanvas when done.
dynamic load(List<Player>players, List<Player>guardians, String skipInit){
	if(doNotRender == true) return checkDone(skipInit);
  var guardians = getGuardiansForPlayers(players);
	loadAllImagesForPlayers(players, guardians,skipInit);
	return null;
}




dynamic loadAllImages(skipInit){
	if(doNotRender == true) return checkDone(skipInit);
	loadOther(skipInit);
	loadAllPossiblePlayers(skipInit);
	return null;
}



/*dynamic loadAllImagesForPlayersNew(players, guardians, skipInit){
	if(simulationMode == true) return checkDone(skipInit);
	var spriteLocations = curSessionGlobalVar.sceneRenderingEngine.loadAllImagesForPlayers(players);
	spriteLocations = spriteLocations.concat(curSessionGlobalVar.sceneRenderingEngine.loadAllImagesForPlayers(guardians));
	for(num i = 0; i<spriteLocations.length; i++){
		loadImage(spriteLocations[i],skipInit);
	}
	loadOther(skipInit);
}*/



dynamic loadAllImagesForPlayerWithCallback(Player player, cb){
	callBack = cb;
	String skipInit = "yes";
	if(doNotRender == true) return checkDone(skipInit);
	loadPlayer(player,skipInit);
	return null;
}



dynamic loadAllImagesForPlayers(List<Player> players, List<Player> guardians, String skipInit){
	if(doNotRender == true) return checkDone(skipInit);
	num numImages = 0;
	//loadFuckingEverything(skipInit); //lol, fuck the world, let's do this shit.

	//same number of players and guardians
	for(num i = 0; i<players.length; i++){
		loadPlayer(players[i],skipInit);
	}
	//guardians aren't going to match players if combo session
	for(num i = 0; i<guardians.length; i++){
		loadPlayer(guardians[i],skipInit);
	}

	loadOther(skipInit);

	return null;
}



//if have x/y/z.png then return z.png;
void urlToID(url){
	var split = url.split("/");
	return split[split.length-1];
}



void addImageTagLoading(url){
  //print(url);
	//only do it if image hasn't already been added.
	if(querySelector("#${escapeId(url)}") == null) {
		//print("I couldn't find a document with id of: " + url);
		String tag = '<img id="' + escapeId(url) + '" src = "images/' + url + '" class="loadedimg">';
		//var urlID = urlToID(url);
		//String tag = '<img id ="' + urlID + '" src = "' + url + '" style="display:none">';
		querySelector("#loading_image_staging").appendHtml(tag,treeSanitizer: NodeTreeSanitizer.trusted);
	}else{
		//print("I thought i found a document with id of: " + url);

	}

}

String escapeId(String toEscape) {
	return toEscape.replaceAll(new RegExp(r"\.|\/"),"_");
}


dynamic checkDone(String skipInit){
  querySelector("#loading_stats").text = ("Images Loaded: $imagesLoaded");
	if((imagesLoaded != 0 && imagesWaiting == imagesLoaded) || doNotRender == true){  //if i'm not using images, don't load them, dunkass.
		//querySelector("#loading").remove(); //not loading anymore
    if(skipInit != null && !skipInit.isEmpty){
		if(callBack != null) return callBack();
      if(skipInit == "oc"){
        print("images loaded: $imagesLoaded");
				throw("not supported yet.");
        //reroll();
        return null;
      }else if(skipInit == "ghosts"){
      	throw("not supported yet.");
        //renderGhosts();
      }else{
        //SimController.instance as CharrenderPlayersForEditing();
      }
      return null;
    }
		SimController.instance.intro();  //TODO this will work for ALL things now, probably can remove skipInit
	}
	return null;
}



void loadImage(String img, String skipInit) {

	if(doNotRender == true) return checkDone(skipInit);
	//print(img);
	imagesWaiting ++;
	ImageElement imageObj = new ImageElement();
  imageObj.onLoad.listen((Event e) {
      //  context.drawImage(imageObj, 69, 50); //i don't want to draw it. i could put it in image staging?
			addImageTagLoading(img);
			imagesLoaded ++;
			checkDone(skipInit);
  });

  imageObj.onError.listen((Event e){
    debug("Error loading image: " + imageObj.src);
		print("Error loading image: " + imageObj.src);
    //alert(this.src);
  });
  imageObj.src = "images/"+img;
//	imageObj.src = img;
}



/*dynamic loadOtherNew(skipInit){
	if(simulationMode == true) return checkDone(skipInit);
	var spriteLocations = curSessionGlobalVar.sceneRenderingEngine.getAllImagesNeededForScenesBesidesPlayers();
	for(num i = 0; i<spriteLocations.length; i++){
		loadImage(spriteLocations[i],skipInit);
	}
}*/



//load pesterchum, blood, big aspect symbols, echeladders, god tier level up, romance symbols, babies, grubs
dynamic loadOther(String skipInit){
	if(doNotRender == true) return checkDone(skipInit);
		loadImage("Credits/recursiveSlacker.png", skipInit);
	  if(cool_kid){
		loadImage("/Bodies/coolk1dlogo.png",skipInit);
		loadImage("/Bodies/coolk1dsword.png",skipInit);
		loadImage("/Bodies/coolk1dshades.png",skipInit);
	  }

	if(ouija){
		  loadImage("/Bodies/pen15.png",skipInit);
	}

	if(faceOff){
		  loadImage("/Bodies/face1.png",skipInit);
			loadImage("/Bodies/face2.png",skipInit);
			loadImage("/Bodies/face3.png",skipInit);
			loadImage("/Bodies/face4.png",skipInit); //wait, aren't there onyl 3 possible faces??? oh god
	}

	loadImage("charSheet.png", skipInit);

	if(bardQuest){
		loadImage("/Bodies/cod.png",skipInit);
	}
	loadImage("jr.png",skipInit);
	loadImage("kr_chat.png",skipInit);
  loadImage("drain_lightning.png", skipInit);
  loadImage("drain_lightning_long.png", skipInit);
  loadImage("drain_halo.png", skipInit);
  loadImage("afterlife_life.png", skipInit);
  loadImage("afterlife_doom.png", skipInit);
  loadImage("doom_res.png", skipInit);
  loadImage("life_res.png", skipInit);
	loadImage("stab.png",skipInit);
  loadImage("denizoned.png",skipInit);
  loadImage("sceptre.png",skipInit);
	loadImage("rainbow.png",skipInit);
  loadImage("ghostGradient.png",skipInit);
	loadImage("halo.png",skipInit);
	loadImage("gears.png",skipInit);
	loadImage("mind_forehead.png",skipInit);
	loadImage("blood_forehead.png",skipInit);
	loadImage("rage_forehead.png",skipInit);
	loadImage("heart_forehead.png",skipInit);
	loadImage("ab.png",skipInit);
	loadImage("grimdark.png",skipInit);
  loadImage("squiddles_chaos.png",skipInit); //re load
	loadImage("fin1.png",skipInit);  //re load
	loadImage("fin2.png",skipInit);  //re load
	loadImage("echeladder.png",skipInit);
	loadImage("godtierlevelup.png",skipInit);
	loadImage("pesterchum.png",skipInit);
	loadImage("blood_puddle.png",skipInit);  //re load
	loadImage("scratch_face.png",skipInit); //re load
	loadImage("robo_face.png",skipInit);  //re load
	loadImage("calm_scratch_face.png",skipInit); //rendering engine will load
	loadImage( "Prospit.png",skipInit);
	//loadImage("Prospit_symbol.png");
	loadImage("Derse.png",skipInit);
	//loadImage("Derse_symbol.png");
	loadImage("bloody_face.png",skipInit);  ///Rendering engine will load
	loadImage("Moirail.png",skipInit);
	loadImage("Matesprit.png",skipInit);
  loadImage("horrorterror.png", skipInit);
  loadImage("dreambubbles.png", skipInit);
	loadImage("Auspisticism.png",skipInit);
	loadImage("Kismesis.png",skipInit);
	loadImage("discuss_romance.png",skipInit);
	loadImage("discuss_ashenmance.png",skipInit);
	loadImage("discuss_palemance.png",skipInit);
	loadImage("discuss_hatemance.png",skipInit);
	loadImage("discuss_breakup.png",skipInit);
	loadImage("discuss_sburb.png",skipInit);
	loadImage("discuss_jack.png",skipInit);
	loadImage("discuss_murder.png",skipInit);
  loadImage("discuss_raps.png",skipInit);
	for(int i = 1; i<4; i++){
		loadImage("Bodies/baby${i}.png",skipInit); //rendering engine will laod
	}

	for(int i = 1; i<4; i++){
		loadImage("Bodies/grub${i}.png",skipInit);
	}
	return null;
}



dynamic loadAllPossiblePlayers(skipInit){
	if(doNotRender == true) return checkDone(skipInit);
	var blankPlayer = new Player(); //need to get num hair and horns.
    num numBodies = 18;  //1 indexed
    var numHair = blankPlayer.maxHairNumber; //+1025 for rufio.  1 indexed
    var numHorns = blankPlayer.maxHornNumber; //1 indexed.
    //var numWings = 12 ;//0 indexed, not 1.  for now, don't bother with wings. not gonna show godtier, for now.;
    for(int i = 1; i<=numBodies; i++){
        loadImage("Bodies/reg${i}.png",skipInit);  //as long as i i do a 'load' again when it's to to start the simulation, can get away with only loading these bodies.
        loadImage("Bodies/god${i}.png",skipInit);
        loadImage("Bodies/dream${i}.png",skipInit);
				loadImage("Bodies/cowl${i}.png",skipInit);
				if(easter_egg == true)   loadImage("Bodies/egg${i}.png",skipInit);
    }

    //error handling
    loadImage("Null.png",skipInit);
    //cause i made images 1 indexed like a dunkass
    loadImage("Bodies/reg256.png",skipInit);
    loadImage("Bodies/dream256.png",skipInit);
    loadImage("Bodies/god256.png",skipInit);
    loadImage("Bodies/cowl256.png",skipInit);




    for(int i = 1; i<=numHair; i++){
        loadImage("Hair/hair_back${i}.png",skipInit);
        loadImage("Hair/hair${i}.png",skipInit);
    }


      for(int i = 0; i<13; i++){
        loadImage("Wings/wing${i}.png",skipInit);
      }

      loadImage("Blood.png",skipInit);
      loadImage("Mind.png",skipInit);
      loadImage("Rage.png",skipInit);
      loadImage("Time.png",skipInit);
      loadImage("Void.png",skipInit);
      loadImage("Heart.png",skipInit);
      loadImage("Breath.png",skipInit);
      loadImage("Light.png",skipInit);
      loadImage("Space.png",skipInit);
      loadImage("Hope.png",skipInit);
      loadImage("Life.png",skipInit);
      loadImage("Doom.png",skipInit);




	loadImage("Hair/hair_back254.png",skipInit);
    loadImage("Hair/hair254.png",skipInit);

    for(int i = 1; i<=numHorns; i++){
        loadImage("Horns/left${i}.png",skipInit);
        loadImage("Horns/right${i}.png",skipInit);
    }

    num maxCustomHorns = 4; //kr doesn't want these widely available.
    for(num i = 255; i> 255-maxCustomHorns; i+=-1){;
        loadImage("Horns/left${i}.png",skipInit);
        loadImage("Horns/right${i}.png",skipInit);
     }
     return null;
}



//load hair, horns, wings, regular sprite, god sprite, fins, aspect symbol, moon symbol for each player
dynamic loadPlayer(Player player, String skipInit){
	if(doNotRender == true) return checkDone(skipInit);
  if(player == null) return null;
	//String imageString = "Horns/right"+player.rightHorn + ".png";
  //addImageTag(imageString);
	loadImage(playerToRegularBody(player),skipInit);
  loadImage(playerToDreamBody(player),skipInit);
	loadImage(playerToGodBody(player),skipInit);
  loadImage(playerToCowl(player),skipInit);
	loadImage("${player.aspect}.png",skipInit);

	loadImage("${player.aspect}Big.png",skipInit);
	loadImage("Hair/hair"+player.hair.toString()+".png",skipInit);
  loadImage("Hair/hair_back"+player.hair.toString()+".png",skipInit);

	if(player.isTroll == true){
		loadImage("Wings/wing"+player.quirk.favoriteNumber.toString() + ".png",skipInit);
		loadImage("Horns/left"+player.leftHorn.toString() + ".png",skipInit);
		loadImage("Horns/right"+player.rightHorn.toString() + ".png",skipInit);
		//loadImage("Bodies/grub"+player.baby + ".png");
	}else{
		//loadImage("Bodies/baby"+player.baby + ".png");
	}
	return null;
}
