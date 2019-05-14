import "dart:html";
import "dart:async";
import "SBURBSim.dart";

num imagesWaiting = 0;
num imagesLoaded = 0;
var globalCallBack = null;

//TODO: look at how babies do async graphics plz

dynamic loadFuckingEverything(Session session, String skipInit, cb){
	if(doNotRender == true) return checkDone(session, skipInit);
	loadAllImages(session,skipInit);
	globalCallBack = cb;
	return null;
}





//load everything while showing a progress bar. delete loadingCanvas when done.
dynamic load(Session session, List<Player>players, List<Player>guardians, String skipInit){
	if(doNotRender == true) return checkDone(session, skipInit);
    var guardians = getGuardiansForPlayers(players);
	loadAllImagesForPlayers(session,players, guardians,skipInit);
	return null;
}




dynamic loadAllImages(Session session, skipInit){
	if(doNotRender == true) return checkDone(session, skipInit);
	loadOther(session,skipInit);
	loadAllPossiblePlayers(session,skipInit);
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



dynamic loadAllImagesForPlayerWithCallback(Session session, Player player, cb){
	globalCallBack = cb;
	String skipInit = "yes";
	if(doNotRender == true) return checkDone(session,skipInit);
	loadPlayer(session,player,skipInit);
	return null;
}



Future<Null> loadAllImagesForPlayers(Session session, List<Player> players, List<Player> guardians, String skipInit) async{
	if(doNotRender == true) return checkDone(session, skipInit);
	if(players.isEmpty) return checkDone(session, skipInit);
	print("loading all images for players $players and guardians $guardians");
	num numImages = 0;
	//loadFuckingEverything(skipInit); //lol, fuck the world, let's do this shit.

	//same number of players and guardians
	for(num i = 0; i<players.length; i++){
		loadPlayer(session,players[i],skipInit);
	}
	//guardians aren't going to match players if combo session
	for(num i = 0; i<guardians.length; i++){
		loadPlayer(session,guardians[i],skipInit);
	}

	loadOther(session,skipInit);

	return null;
}



//if have x/y/z.png then return z.png;
void urlToID(url){
	var split = url.split("/");
	return split[split.length-1];
}



void addImageTagLoading(url){
  ////print(url);
	//only do it if image hasn't already been added.
	if(querySelector("#${escapeId(url)}") == null) {
		////print("I couldn't find a document with id of: " + url);
		String tag = '<img id="' + escapeId(url) + '" src = "images/' + url + '" class="loadedimg">';
		//var urlID = urlToID(url);
		//String tag = '<img id ="' + urlID + '" src = "' + url + '" style="display:none">';
		querySelector("#loading_image_staging").appendHtml(tag,treeSanitizer: NodeTreeSanitizer.trusted);
	}else{
		////print("I thought i found a document with id of: " + url);

	}

}

String escapeId(String toEscape) {
	return toEscape.replaceAll(new RegExp(r"\.|\/"),"_");
}


void checkDone(Session session, String skipInit){
    if(querySelector("#loading_stats") != null) querySelector("#loading_stats").text = ("Images Loaded: $imagesLoaded");
	if((imagesLoaded != 0 && imagesWaiting == imagesLoaded) || doNotRender == true){  //if i'm not using images, don't load them, dunkass.
		//querySelector("#loading").remove(); //not loading anymore
    if(skipInit != null && !skipInit.isEmpty){
    	print("global callback is $globalCallBack ");
		if(globalCallBack != null) return globalCallBack();
      if(skipInit == "oc"){
        //print("images loaded: $imagesLoaded");
				throw("not supported yet.");
        //reroll();
        return null;
      }else if(skipInit == "ghosts"){
	      throw("deprecated, dunkass");
      }else{
        //SimController.instance as CharrenderPlayersForEditing();
      }
      return null;
    }
		session.intro();  //TODO this will work for ALL things now, probably can remove skipInit
	}
	return null;
}



void loadImage(Session session, String img, String skipInit) {

	if(doNotRender == true) return checkDone(session, skipInit);
	////print(img);
	imagesWaiting ++;
	ImageElement imageObj = new ImageElement();
  imageObj.onLoad.listen((Event e) {
      //  context.drawImage(imageObj, 69, 50); //i don't want to draw it. i could put it in image staging?
			addImageTagLoading(img);
			imagesLoaded ++;
			checkDone(session, skipInit);
  });

  imageObj.onError.listen((Event e){
    debug("Error loading image: ${imageObj.src} $e");
		//print("Error loading image: " + imageObj.src);
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
dynamic loadOther(Session session, String skipInit){
	if(doNotRender == true) return checkDone(session,skipInit);
		loadImage(session,"Credits/recursiveSlacker.png", skipInit);
	  if(cool_kid){
		loadImage(session,"/Bodies/coolk1dlogo.png",skipInit);
		loadImage(session,"/Bodies/coolk1dsword.png",skipInit);
		loadImage(session,"/Bodies/coolk1dshades.png",skipInit);
	  }

	if(ouija){
		  loadImage(session,"/Bodies/pen15.png",skipInit);
	}

	if(faceOff){
		  loadImage(session,"/Bodies/face1.png",skipInit);
			loadImage(session,"/Bodies/face2.png",skipInit);
			loadImage(session,"/Bodies/face3.png",skipInit);
			loadImage(session,"/Bodies/face4.png",skipInit); //wait, aren't there onyl 3 possible faces??? oh god
	}

	loadImage(session,"charSheet.png", skipInit);
	loadImage(session,"Rewards/no_reward.png", skipInit);
	loadImage(session,"Rewards/holyAlchemy.png", skipInit);
	loadImage(session,"Rewards/sweetFrog.png", skipInit);
	loadImage(session,"Rewards/sweetFriendship.png", skipInit);
	loadImage(session,"Rewards/bitterFrog.png", skipInit);
	loadImage(session,"Rewards/holyShitFrogs.png", skipInit);
	loadImage(session,"Rewards/sweetLoot.png", skipInit);
	loadImage(session,"Rewards/sweetGrist.png", skipInit);
	loadImage(session,"Rewards/sweetTreasure.png", skipInit);
	loadImage(session,"Rewards/fraymotifBG.png", skipInit);
	loadImage(session,"Rewards/sweetBoonies.png", skipInit);
	loadImage(session,"Rewards/ohShit.png", skipInit);
	loadImage(session,"Rewards/sweetClock.png", skipInit);
	loadImage(session,"Rewards/battlefield.png", skipInit);

	loadImage(session,"/Bodies/cod.png",skipInit);
	loadImage(session,"/Rewards/sweetCod.png",skipInit);

	loadImage(session,"jr.png",skipInit);
	loadImage(session,"kr_chat.png",skipInit);
  loadImage(session,"drain_lightning.png", skipInit);
  loadImage(session,"drain_lightning_long.png", skipInit);
  loadImage(session,"drain_halo.png", skipInit);
  loadImage(session,"afterlife_life.png", skipInit);
  loadImage(session,"afterlife_doom.png", skipInit);
  loadImage(session,"doom_res.png", skipInit);
  loadImage(session,"life_res.png", skipInit);
	loadImage(session,"stab.png",skipInit);
  loadImage(session,"denizoned.png",skipInit);
  loadImage(session,"sceptre.png",skipInit);
	loadImage(session,"rainbow.png",skipInit);
  loadImage(session,"ghostGradient.png",skipInit);
	loadImage(session,"halo.png",skipInit);
	loadImage(session,"gears.png",skipInit);
	loadImage(session,"mind_forehead.png",skipInit);
	loadImage(session,"blood_forehead.png",skipInit);
	loadImage(session,"rage_forehead.png",skipInit);
	loadImage(session,"heart_forehead.png",skipInit);
	loadImage(session,"ab.png",skipInit);
	loadImage(session,"shogun.png",skipInit);
	loadImage(session,"grimdark.png",skipInit);
  loadImage(session,"squiddles_chaos.png",skipInit); //re load
	loadImage(session,"fin1.png",skipInit);  //re load
	loadImage(session,"fin2.png",skipInit);  //re load
	loadImage(session,"echeladder.png",skipInit);
	loadImage(session,"godtierlevelup.png",skipInit);
	loadImage(session,"cataclysm.png",skipInit);
	loadImage(session,"pesterchum.png",skipInit);
	loadImage(session,"blood_puddle.png",skipInit);  //re load
	loadImage(session,"scratch_face.png",skipInit); //re load
	loadImage(session,"robo_face.png",skipInit);  //re load
	loadImage(session,"calm_scratch_face.png",skipInit); //rendering engine will load
	loadImage(session, "Prospit.png",skipInit);
	//loadImage(session,"Prospit_symbol.png");
	loadImage(session,"Derse.png",skipInit);
	//loadImage(session,"Derse_symbol.png");
	loadImage(session,"bloody_face.png",skipInit);  ///Rendering engine will load
	loadImage(session,"Moirail.png",skipInit);
	loadImage(session,"Matesprit.png",skipInit);
  loadImage(session,"horrorterror.png", skipInit);
  loadImage(session,"dreambubbles.png", skipInit);
	loadImage(session,"Auspisticism.png",skipInit);
	loadImage(session,"Kismesis.png",skipInit);
	loadImage(session,"discuss_romance.png",skipInit);
	loadImage(session,"discuss_ashenmance.png",skipInit);
	loadImage(session,"discuss_palemance.png",skipInit);
	loadImage(session,"discuss_hatemance.png",skipInit);
	loadImage(session,"discuss_breakup.png",skipInit);
	loadImage(session,"discuss_sburb.png",skipInit);
	loadImage(session,"discuss_jack.png",skipInit);
	loadImage(session,"discuss_murder.png",skipInit);
  loadImage(session,"discuss_raps.png",skipInit);
	return null;
}



dynamic loadAllPossiblePlayers(Session session, skipInit){
	if(doNotRender == true) return checkDone(session, skipInit);
    num numBodies = 21;  //1 indexed
    var numHair = Player.maxHairNumber; //+1025 for rufio.  1 indexed
    var numHorns = Player.maxHornNumber; //1 indexed.
    //var numWings = 12 ;//0 indexed, not 1.  for now, don't bother with wings. not gonna show godtier, for now.;
    for(int i = 1; i<=numBodies; i++){
        loadImage(session,"Bodies/reg${i}.png",skipInit);  //as long as i i do a 'load' again when it's to to start the simulation, can get away with only loading these bodies.
        loadImage(session,"Bodies/god${i}.png",skipInit);
        loadImage(session,"Bodies/dream${i}.png",skipInit);
				loadImage(session,"Bodies/cowl${i}.png",skipInit);
				if(easter_egg == true)   loadImage(session,"Bodies/egg${i}.png",skipInit);
    }

    //error handling
    loadImage(session,"Null.png",skipInit);
    //cause i made images 1 indexed like a dunkass
    loadImage(session,"Bodies/reg256.png",skipInit);
    loadImage(session,"Bodies/dream256.png",skipInit);
    loadImage(session,"Bodies/god256.png",skipInit);
    loadImage(session,"Bodies/cowl256.png",skipInit);




    for(int i = 1; i<=numHair; i++){
        loadImage(session,"Hair/hair_back${i}.png",skipInit);
        loadImage(session,"Hair/hair${i}.png",skipInit);
    }


      for(int i = 0; i<13; i++){
        loadImage(session,"Wings/wing${i}.png",skipInit);
      }

      loadImage(session,"Blood.png",skipInit);
      loadImage(session,"Mind.png",skipInit);
      loadImage(session,"Rage.png",skipInit);
      loadImage(session,"Time.png",skipInit);
      loadImage(session,"Void.png",skipInit);
      loadImage(session,"Heart.png",skipInit);
      loadImage(session,"Breath.png",skipInit);
	  loadImage(session,"Dream.png",skipInit);
      loadImage(session,"Light.png",skipInit);
      loadImage(session,"Space.png",skipInit);
      loadImage(session,"Hope.png",skipInit);
      loadImage(session,"Life.png",skipInit);
      loadImage(session,"Doom.png",skipInit);




	loadImage(session,"Hair/hair_back254.png",skipInit);
    loadImage(session,"Hair/hair254.png",skipInit);

    for(int i = 1; i<=numHorns; i++){
        loadImage(session,"Horns/left${i}.png",skipInit);
        loadImage(session,"Horns/right${i}.png",skipInit);
    }

    num maxCustomHorns = 4; //kr doesn't want these widely available.
    for(num i = 255; i> 255-maxCustomHorns; i+=-1){;
        loadImage(session,"Horns/left${i}.png",skipInit);
        loadImage(session,"Horns/right${i}.png",skipInit);
     }
     return null;
}



//load hair, horns, wings, regular sprite, god sprite, fins, aspect symbol, moon symbol for each player
dynamic loadPlayer(Session session, Player player, String skipInit){
	if(doNotRender == true) return checkDone(session,skipInit);
  if(player == null) return null;
	//String imageString = "Horns/right"+player.rightHorn + ".png";
  //addImageTag(imageString);
	loadImage(session,Drawing.playerToRegularBody(player),skipInit);
  loadImage(session,Drawing.playerToDreamBody(player),skipInit);
	loadImage(session,Drawing.playerToGodBody(player),skipInit);
  loadImage(session,Drawing.playerToCowl(player),skipInit);
	loadImage(session,"${player.aspect.symbolImgLocation}",skipInit);

	loadImage(session,"${player.aspect.bigSymbolImgLocation}",skipInit);
	loadImage(session,"Hair/hair"+player.hair.toString()+".png",skipInit);
  loadImage(session,"Hair/hair_back"+player.hair.toString()+".png",skipInit);

	if(player.isTroll == true){
		loadImage(session,"Wings/wing"+player.quirk.favoriteNumber.toString() + ".png",skipInit);
		loadImage(session,"Horns/left"+player.leftHorn.toString() + ".png",skipInit);
		loadImage(session,"Horns/right"+player.rightHorn.toString() + ".png",skipInit);
		//loadImage(session,"Bodies/grub"+player.baby + ".png");
	}else{
		//loadImage(session,"Bodies/baby"+player.baby + ".png");
	}
	return null;
}
