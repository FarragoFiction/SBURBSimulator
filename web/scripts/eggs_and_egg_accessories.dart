part of SBURBSim;




void bardQuestMode(){
	if(window.confirm("Behold the Majesty of the CodTier? Y/N")){
		bardQuest = true;
	}else{
		window.alert("But thou must!f");
		bardQuestMode();
	}

}



void faceOffMode(){
	faceOff = true;
	window.alert("Wait...so...if this is 'face off' mode....does that mean the creepy flesh masks were their real faces all along, and THIS is what was hidden underneath???");
	for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		curSessionGlobalVar.players[i].grimDark = 4;
	}
}



void pen15Ouija(){
	ouija = true;
	window.alert("thats the spooky thing about penis ouija you can never be sure who did the dicks");
	window.alert("was it you or me or maybe a ghoooost???");
	querySelector('body').style.backgroundColor = "#f8c858";
	querySelector('body').style.backgroundImage = "url(images/pen15_bg1.png)";
}



void coolK1DMode(){
	window.alert("H3Y TH3R3 COOL K1D 1S TH1S YOU???");
}



//no. you gots to flip it TURN-WAYS, dunkass.
//rendering shouldu be different
//making new scenes to be different
void sbahjMode(){
	if(!doNotRender) window.alert("where MAKING THIS HAPEN");
	//when kr has their stuff read, render it after everything else is done , or just, like put it on a 30 second timer. needs comedic timing, needs to be on top
	//maybe my laughing reaction shot sbahj_author.jpg goes then, too
	appendHtml(querySelector("#story"),"<img src = 'images/AUTHORSBAHJ.jpg' style='position:absolute; top:111px'><img src = 'images/sbahj_author.jpg' style='position:absolute; left:0px; z-index: 999;'>");


	new Timer(new Duration(milliseconds: 10000), () =>appendHtml(querySelector("#story"),"<img src = 'images/kR_falls_DOWN_stairs_forever.gif' style='position:fixed; top:0px;; z-index: 999;'>"));

	querySelector('body').style.backgroundColor = "#0000ff";
	querySelector('body').style.backgroundImage = "none";
	querySelector('#story').style.backgroundColor = "#ff00ff";
	curSessionGlobalVar.sbahj = true;
	for(num j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.sbahj = true;
		p.quirk.lettersToReplaceIgnoreCase =sbahj_quirks;
	}
}



//will get called twice for initialization purposes.
void checkEasterEgg(callBack, that){  //only yellow yard session uses 'that' because it needs to get back to the session context after doing easter egg.
	//authorMessage();
	//i cannot resist
	if(curSessionGlobalVar.session_id == 413){
		session413();
	}else if(curSessionGlobalVar.session_id == 612){
		session612();
	}else if(curSessionGlobalVar.session_id == 613){
		session613();
	}else if(curSessionGlobalVar.session_id == 1025){
		session1025();
	}else if(curSessionGlobalVar.session_id == 33){
		session33();
	}else if(curSessionGlobalVar.session_id == 111111){
		session111111();
	}else if(curSessionGlobalVar.session_id == 88888888){
		session88888888();
	}else if(curSessionGlobalVar.session_id == 420){
		session420();
	}else if(curSessionGlobalVar.session_id == 0){
		session0();
	}

	if(getParameterByName("images",null)  == "pumpkin"){
		doNotRender = true;
	}

	if(getParameterByName("easter",null)  == "egg"){
		easter_egg = true;
		window.alert("Yo Dawg, I herd you liek easter eggs???");
	}


	if(getParameterByName("selfInsertOC",null)  == "true"){
		// call a method, method will determine what other params exist, like reddit=true and shit.;
		processFanOCs(callBack,that);
		return; //do nothing else. processFanOCs will handle the callback, since it's the reason it exists in the first place, 'cause async
	}

	//not an else if because this OVERIDES other easter egg sessions. but called here and not where other params are 'cause needs to have session initialized first.
	if(getParameterByName("nepeta",null)  == ":33"){
		nepetaQuest(); //ANY session can be all nepetas.
	}

	if(getParameterByName("luck",null)  == "AAAAAAAALL"){
		lucky8rk();
	}

	if(getParameterByName("honk",null)  == ":o)"){
		fridgeQuest();
	}

	if(getParameterByName("shenanigans",null)  == "temporal"){
		aradiaQuest();
	}

	if(getParameterByName("home",null)  == "stuck"){
		homestuck();
	}

	if(getParameterByName("hive",null)  == "bent"){
		hivebent();
	}

	if(getParameterByName("open",null)  == "bound"){
		openBound();
	}

	if(getParameterByName("rumpus",null)  == "fruity"){
		fruityRumpusAssholeFactory();
	}

	if(getParameterByName("lawnring",null)  == "yellow"){
		janusReward();
	}

	processXStuck(); //might not do anything.
  if(that != null) {
    callBack(that); //TODO might never need to do this again in Dart.
  }else {
    callBack();
  }
}



void janusReward(){
	curSessionGlobalVar.janusReward = true;
}



//omg, so easy, KnightStuck = true, SylphStuck = true, PageStuck = true.;
//if last word is stuck, look for first word in either all class, or all aspects, mod the approriate thing to be the first word.
//auto works with new claspects, too. genius
void processXStuck(){
	//TODO get this working again. window.location.search is empty.
	if(window.location.search.isEmpty) return ;
	String params1 = window.location.search.substring(0);
	String params2 = simulatedParamsGlobalVar;
	print("~~~~~~~~~~~~~~~~~~params2 is " + params2);
	var tmp = new List<String>.from(classes);
	tmp.addAll(custom_only_classes);
	String params = "";
	if(params1 != null){
		params = params1;
		if(params2!= null){
			params += "&" + params2;
		}
	}else if(params2 != null) params = params2;
	var paramsArray = params.split("&");
	for(num i = 0; i<paramsArray.length; i++){
		var stuck = paramsArray[i].split("Stuck");
		print("stuck is: " + stuck.toString());
		if(stuck.length == 2){
			var classOrAspect = stuck[0];
			if(tmp.indexOf(stuck[0]) != -1){
				setAllClassesTo(stuck[0].trim());
			}else if(all_aspects.indexOf(stuck[0]) != -1){
				setAllAspectsTo(stuck[0].trim());
			}
		}
	}

}



void setAllAspectsTo(aspect){
	print("Setting all aspects to: " + aspect);
	for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		if(curSessionGlobalVar.players[i].aspect != "Time" && curSessionGlobalVar.players[i].aspect != "Space" ) curSessionGlobalVar.players[i].aspect = aspect; //You can have no space/time in your own sessions, but AB will never do it on purpose.
		if(curSessionGlobalVar.players[i].guardian.aspect != "Time" && curSessionGlobalVar.players[i].guardian.aspect != "Space" ) curSessionGlobalVar.players[i].guardian.aspect = aspect;
	}
}



void setAllClassesTo(class_name){
	print("Setting all classes to: " + class_name);
	for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		curSessionGlobalVar.players[i].class_name = class_name;
		curSessionGlobalVar.players[i].guardian.class_name = class_name;
	}
}



void processFanOCs(callBack, that){
	//start up an easterEggEngine.
	new CharacterEasterEggEngine().loadArraysFromFile(callBack,true,that); //<-- ASYNCHRONOUS, so MUST END HERE. any future steps should be in the easterEggEngine itself.
}






void babyStuckMode(){
	if(!doNotRender) window.alert("goo goo GA GAH!");
	for(num j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.baby_stuck = true;
		p.quirk.lettersToReplaceIgnoreCase.addAll([["e", "goo"],["a","gah"],["i","ga"],["o","blooo"],["u","guuuu"]]);
	}
}



//AB told me this was funny! I SWEAR I am not Robo-Racist! It's IRONIC.
void roboMode(){
	if(!doNotRender) window.alert("BEEP");
	appendHtml(querySelector("#story"),"<img src = 'images/guide_bot.png' style='float:left;'>");
	for(num j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.hairColor = getRandomGreyColor();
		p.bloodColor = getRandomGreyColor();
		p.robot  = true;
		p.addStat("power",20); //Robots are superior.
		p.quirk.capitalization = 2; //OBVIOUSLY robots all speak in all caps.
		p.quirk.punctuation = 0; //robots speak in monotone, DUH.
		p.quirk.lettersToReplaceIgnoreCase.add(["\\bhuh\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.add(["\\ber\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.add(["\\bhrmm\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.add(["\\bum\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.add(["\\buh\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.add(["\\boh\\b","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.add(["fuck","BEEP"]);
		p.quirk.lettersToReplaceIgnoreCase.add(["ass","BEEP"]);
		for(num k = 0; k <p.relationships.length; k++){
				var r = p.relationships[k];
				r.value = 0.00001; // Clearly they are just tin cans without feelings. Robo, or otherwise.  if i set it to zero, they never even bother to talk to each other....
		}
	}
}



void tricksterMode(){
	if(!doNotRender) window.alert("I FEEL JUST PEEEEEEEEEEEACHY!!!!!!!!!!!");
	if(doNotRender) (querySelector("#avatar") as ImageElement).src = "images/CandyAuthorBot.png";
	appendHtml(querySelector("#story"),"<img src = 'images/trickster_author.png' style='float:left;'><img src = 'images/trickster_artist.png' style='float:left;'>");
	querySelector('body').style.backgroundImage =  "url(images/zilly.gif)"; //.style.backgroundColor
	querySelector('#story').style.backgroundColor ="#ff93e4";
	for(num j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		if(p.aspect != "Doom"){ //kr says it would be funny if doom plalyers completely immune.
			p.hairColor = curSessionGlobalVar.rand.pickFrom(tricksterColors);
			p.bloodColor = curSessionGlobalVar.rand.pickFrom(tricksterColors);
			p.trickster  = true;
		}else{
		}


		if(p.aspect != "Heart" && p.aspect != "Doom"){//no personality changes.
			p.quirk.capitalization = 2;
			p.quirk.punctuation = 3;
			p.quirk.favoriteNumber = 11;
			for(num k = 0; k <p.relationships.length; k++){
				var r = p.relationships[k];
				r.value = 111111; //EVERYTHIGN IS BETTER!!!!!!!!!!!
			}
		}
		if(p.aspect != "Doom"){
			p.setStat("power",  111111);
			p.landLevel = 111111;
			p.level_index = 111111;
		}


	}
}



void debugRoyalRumble(){
	if(!doNotRender) window.alert("royal rumble!");
	for(num j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		p.isTroll = true; //only .evel 2 players up
		p.bloodColor = "#99004d";
		p.addStat("sanity",-10);
		p.decideLusus();
		p.object_to_prototype = p.myLusus;
		p.relationships = [];
		p.quirk = null;
		p.generateRelationships(curSessionGlobalVar.players);  //heiresses hate each other
		p.quirk = randomTrollSim(curSessionGlobalVar.rand, p);
	}

}


void session413(){
	print("413");
	for(int i = 0; i<8; i++){
		Player player;
		Player guardian;
		if(i< curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
			print("using existing player");
		}else{
			print("making new player");
			player = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomHumanSim(curSessionGlobalVar.rand, guardian);
			player.quirk = randomHumanSim(curSessionGlobalVar.rand, player);
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.add(player);
		}
	}

	for(int i = 0; i<8; i++){
		Player player = curSessionGlobalVar.players[i];
		Player guardian = player.guardian;
		player.relationships = [];
		List<Player> guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(curSessionGlobalVar.players);
		session413IndexToHuman(player, i);
		session413IndexToAncestor(guardian, i);//just call regular with a different index
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}



void session111111(){
	for(int i = 0; i<8; i++){
		Player  player;
		Player guardian;
		if(i< curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomHumanSim(curSessionGlobalVar.rand,guardian);
			player.quirk = randomHumanSim(curSessionGlobalVar.rand,player);
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.add(player);
		}
	}

	for(int i = 0; i<8; i++){
		Player player = curSessionGlobalVar.players[i];
		Player guardian = player.guardian;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(curSessionGlobalVar.players);
		session413IndexToAncestor(player, i);
		session413IndexToHuman(guardian, i);//just call regular with a different index
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}



void session413IndexToHuman(player, index){
	player.isTroll = false;
	player.deriveChatHandle = false;
	if(index == 0){
		player.bloodColor = "#ff0000";
		player.class_name = "Heir";
		player.godDestiny = true;
		player.aspect = "Breath";
		player.hair  =3;
		player.hairColor = "#000000";
		player.chatHandle = "ectoBiologist";
		player.interest1 = "Pranks";
		player.interest2 = "Action Movies";
		player.kernel_sprite = "Clown";
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","hehehe"]];
		player.land = "Land of Wind and Shade";
		player.moon = "Prospit";
	}else if(index == 1){
		player.moon = "Derse";
		player.bloodColor = "#ff0000";
		player.godDestiny = true;
		player.class_name = "Seer";
		player.land = "Land of Light and Rain";
		player.aspect = "Light";
		player.chatHandle = "tentacleTherapist";
		player.interest1 = "Writing";
		player.interest2 = "Horrorterrors";
		player.hair  =20;
		player.hairColor = "#fff3bd";
		player.kernel_sprite = "Cat";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","greetings"],["yes", "certainly"]];
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 2){
		player.moon = "Derse";
		player.bloodColor = "#ff0000";
		player.class_name = "Knight";
		player.land = "Land of Heat and Clockwork";
		player.aspect = "Time";
		player.hairColor = "#feffd7";
		player.hair  =1;
		player.chatHandle = "turntechGodhead";
		player.interest1 = "Rap";
		player.interest2 = "Irony";
		player.kernel_sprite = "Puppet";
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","sup"]];
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 3){
		player.moon = "Prospit";
		player.bloodColor = "#ff0000";
		player.class_name = "Witch";
		player.land = "Land of Frost and Frogs";
		player.aspect = "Space";
		player.hair  =9;
		player.hairColor = "#3f1904";
		player.chatHandle = "gardenGnostic";
		player.interest1 = "Physics";
		player.interest2 = "Gardening";
		player.kernel_sprite = "First Guardian";
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 3;
		player.favoriteNumber = 5;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 4){
		player.moon = "Prospit";
		player.bloodColor = "#ff0000";
		player.class_name = "Maid";
		player.godDestiny = true;
		player.aspect = "Life";
		player.land = "Land of Crypts and Helium";
		player.hair  =38;
		player.hairColor = "#000000";
		player.chatHandle = "gutsyGumshoe";
		player.interest1 = "Pranks";
		player.interest2 = "Baking";
		player.kernel_sprite = "Mistake";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","hoo hoo"]];
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 5){
		player.moon = "Derse";
		player.bloodColor = "#ff0000";
		player.class_name = "Rogue";
		player.land = "Land of Pyramids and Neon";
		player.aspect = "Void";
		player.hair  =24;
		player.hairColor = "#fff3bd";
		player.chatHandle = "tipsyGnostalgic";
		player.interest1 = "Writing";
		player.interest2 = "Wizards";
		//HI!!! HOW ARE YOU!?
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["like","liek"], ["school","skool"]];
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		player.kernel_sprite = "Troll";
	}else if(index == 6){
		player.moon = "Derse";
		player.bloodColor = "#ff0000";
		player.class_name = "Prince";
		player.land = "Land of Tombs and Krypton";
		player.aspect = "Heart";
		player.hair  =36;
		player.hairColor = "#feffd7";
		player.chatHandle = "timaeusTestified";
		player.interest1 = "Irony";
		player.interest2 = "Robots";
		player.kernel_sprite = "Robot Horse Weirdo";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","sup"]];
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";

	}else if(index == 7){
		player.moon = "Prospit";
		player.bloodColor = "#ff0000";
		player.class_name = "Page";
		player.land = "Land of Mounds and Xenon";
		player.aspect = "Hope";
		player.hair  =37;
		player.hairColor = "#3f1904";
		player.chatHandle = "golgothasTerror";
		player.interest1 = "Physics";
		player.interest2 = "Movies";
		player.kernel_sprite = "Buddy";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","good one"]];
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}

}



//just hange index and return whatever regular does. pretend janes goes in first;
void session413IndexToAncestor(player, index){
	player.isTroll = false;
	if(index == 0){
		session413IndexToHuman(player, 4);
	}else if(index == 1){
		session413IndexToHuman(player, 5);
	}else if(index == 2){
		session413IndexToHuman(player, 6);
	}else if(index == 3){
		session413IndexToHuman(player, 7);
	}else if(index == 4){
		session413IndexToHuman(player, 0);
	}else if(index == 5){
		session413IndexToHuman(player, 1);
	}else if(index == 6){
		session413IndexToHuman(player, 2);
	}else if(index == 7){
		session413IndexToHuman(player, 3);
	}
}





//time player is dave space player is either jade
//all else is 413 human.
void homestuck(){
	//var savedSeed = curSessionGlobalVar.session_id;
	Random rand = new Random(curSessionGlobalVar.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random
	//copyPlayerFromTemplate(p,template);
	for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		var p = curSessionGlobalVar.players[i];
		var g = p.guardian;
		if(p.aspect == "Time"){
			session413IndexToHuman(p,2);
			session413IndexToAncestor(g,2);
		}else if(p.aspect == "Space"){
			session413IndexToHuman(p,3);
			session413IndexToHuman(g,3);
		}else{
			var index = rand.nextIntRange(0,7);
			session413IndexToHuman(p,index);
			session413IndexToAncestor(g,index);
		}
	}
}



//time player is aradia, space player is kanaya,
//all else random alternian troll
void hivebent(){
  Random rand = new Random(curSessionGlobalVar.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random

  for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		var p = curSessionGlobalVar.players[i];
		var g = p.guardian;
		if(p.aspect == "Time"){
			session612IndexToTroll(p,4);
			session612IndexToTrollAncestor(g,4);
		}else if(p.aspect == "Space"){
			session612IndexToTroll(p,8);
			session612IndexToTrollAncestor(g,8);
		}else{
			var index = rand.nextIntRange(0,11);
			session612IndexToTroll(p,index);
			session612IndexToTrollAncestor(g,index);
		}
	}
}



//time player is damara, space player is porrim
//all else random beforan troll
void openBound(){
  Random rand = new Random(curSessionGlobalVar.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random

  for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		var p = curSessionGlobalVar.players[i];
		var g = p.guardian;
		if(p.aspect == "Time"){
			session612IndexToTroll(g,4);
			session612IndexToTrollAncestor(p,4);
		}else if(p.aspect == "Space"){
			session612IndexToTroll(g,8);
			session612IndexToTrollAncestor(p,8);
		}else{
			var index = rand.nextIntRange(0,11);
			session612IndexToTroll(g,index);
			session612IndexToTrollAncestor(p,index);
		}
	}
}



//time player is aradia, damara or dave, space is jade, porrim or kanaya
//all else is randomly alternian or beforan or human.
//rumpus = fruity;
//i will have order in this rumpusBlock! Or the opposite !!!
void fruityRumpusAssholeFactory(){
  Random rand = new Random(curSessionGlobalVar.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random
  for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		var p = curSessionGlobalVar.players[i];
		var g = p.guardian;
		var randNum = rand.nextDouble();
		if(p.aspect == "Time"){
			if(randNum > 0.6){
				session612IndexToTroll(g,4);
				session612IndexToTrollAncestor(p,4);
			}else if(randNum > 0.3){
				session612IndexToTrollAncestor(p,4);
				session612IndexToTroll(g,4);
			}else{
				session413IndexToHuman(p,2);
				session413IndexToHuman(g,2);
			}
		}else if(p.aspect == "Space"){
			if(randNum > 0.6){
				session612IndexToTroll(g,8);
				session612IndexToTrollAncestor(p,8);
			}else if(randNum > 0.3){
				session612IndexToTrollAncestor(p,8);
				session612IndexToTroll(g,8);
			}else{
				session413IndexToHuman(p,3);
				session413IndexToHuman(g,3);
			}
		}else{
			if(randNum > 0.6){
				var index = rand.nextIntRange(0,12);
				session612IndexToTroll(g, index);
				session612IndexToTrollAncestor(p,index);
			}else if(randNum > 0.3){
				var index = rand.nextIntRange(0,12);
				session612IndexToTrollAncestor(p,index);
				session612IndexToTroll(g,index);
			}else{
				var index = rand.nextIntRange(0,7);
				session413IndexToHuman(p,index);
				session413IndexToAncestor(g,index);
			}
		}
	}
}




//like nepeta quest, but with gamzee instead of nepeta.
void aradiaQuest(){

	for(num i = 0; i< curSessionGlobalVar.players.length; i++){
		var player = blankPlayerNoDerived(curSessionGlobalVar); //unlike gamzee or vriska, aradias can be different
		session612IndexToTroll(player, 4);
		var p = curSessionGlobalVar.players[i];
		var g = p.guardian;
		p.id = i;
		g.id = i + 111111;
		copyPlayerFromTemplate(p,player);
		copyPlayerFromTemplate(g,player);
	}
}



//like nepeta quest, but with gamzee instead of nepeta.
void fridgeQuest(){
	var player = blankPlayerNoDerived(curSessionGlobalVar);
	session612IndexToTroll(player, 2);
	copyPlayersFromTemplate(player);
}




//everyone replaced by vriska. thief of space and thief of time.
void lucky8rk(){
	var player = blankPlayerNoDerived(curSessionGlobalVar);
	session612IndexToTroll(player, 7);
	copyPlayersFromTemplate(player);
}



void copyPlayerFromTemplate(Player p, Player template){
	if(p.aspect != "Time" && p.aspect != "Space"){
		p.aspect = template.aspect;
	}
	p.isTroll = template.isTroll;
	p.class_name = template.class_name;
	p.quirk = template.quirk;
	p.leftHorn = template.leftHorn;
	p.rightHorn = template.rightHorn;
	p.hair = template.hair;
	p.bloodColor = template.bloodColor;
	p.hairColor = template.hairColor;
	p.godDestiny = template.godDestiny;
	p.robot = template.robot;
	p.dead = template.dead;
	p.chatHandle = template.chatHandle;
	p.interest1 = template.interest1;
	p.interest2 = template.interest2;
	p.mylevels = template.mylevels;
}



//don't use for nepeta quest because true random roleplay
void copyPlayersFromTemplate(template){
	for(num i = 0; i< curSessionGlobalVar.players.length; i++){
		var p = curSessionGlobalVar.players[i];
		var g = p.guardian;
		p.id = i;
		g.id = i + 111111;
		copyPlayerFromTemplate(p,template);
		copyPlayerFromTemplate(g,template);
	}
}




//call this ONLY after initializing normal players.
void nepetaQuest(){
	querySelector('body').style.backgroundImage = "url(images/cat_background_tile_nep.png)";
	//will it be 12 nepetas roleplaying as their original players?
	//or 12 canon trolls all roleplaying as nepeta?
	//it's shrodinger's nepeta!!!
	var actualRandomNumber = new Random().nextInt(); //no fucking seed.

	for(num i = 0; i< curSessionGlobalVar.players.length ;i++){
		Player player = curSessionGlobalVar.players[i];
    Player guardian = player.guardian;
		player.isTroll = true;
		guardian.isTroll = true;
		if(actualRandomNumber > .5 && player.aspect != "Time" && player.aspect != "Space"){ //just cause they are roleplaying as nepeta doesn't mean their claspect changes.
			player.aspect = "Heart";
		}
		player.class_name = "Rogue";
		if(guardian.aspect != "Time" && guardian.aspect != "Space"){
			guardian.aspect = "Heart";

		}
		guardian.class_name = "Rogue";
		player.hair = 7;
		player.leftHorn = 22;
		player.rightHorn = 22;
		if(actualRandomNumber > .5){
			player.bloodColor = "#416600"; //actually is nepeta.
			guardian.bloodColor = "#416600";
			player.quirk.favoriteNumber = 3;
			guardian.quirk.favoriteNumber = 3;
		}else{
			player.quirk.lettersToReplaceIgnoreCase.addAll([["ee","33"], ["per","purr"]]);//trying to reoleplay as nepeta, but badly.
			player.quirk.lettersToReplaceIgnoreCase.addAll([["ee","33"], ["per","purr"]]);
		}

		guardian.hair = 7;
		guardian.leftHorn = 22;
		guardian.rightHorn = 22;
	}
}



void session88888888(){
	curSessionGlobalVar.players = []; //rip players, too bad about the 8ad 8rk
	for(int i = 0; i<8; i++){
		var player;
		var guardian;
		player = blankPlayerNoDerived(curSessionGlobalVar);
		guardian = blankPlayerNoDerived(curSessionGlobalVar);
		if(i == 0){
			player.leader = true;
			guardian.leader = true;
			player.aspect = "Space";
			guardian.aspect = "Space";
		}else if(i == 1){
			player.aspect = "Time";
			guardian.aspect = "Time";
		}
		player.guardian = guardian;
		guardian.guardian = player;
		curSessionGlobalVar.players.add(player);
	}
	lucky8rk();
	for(num i = 0; i<curSessionGlobalVar.players.length;i++){
		var player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		if(i == 0){
			player.leader = true;
			guardian.leader = true;
			player.aspect == "Space";
			guardian.aspect == "Space";
		}else if(i == 1){
			player.aspect == "Time";
			guardian.aspect == "Time";
		}
		player.relationships = [];
		guardian.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(curSessionGlobalVar.players);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}



void session420(){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i>curSessionGlobalVar.players.length){
			print("blank player");
			player = blankPlayerNoDerived(curSessionGlobalVar);
			guardian = blankPlayerNoDerived(curSessionGlobalVar);
			player.initialize();
			guardian.initialize();
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.add(player);
		}
	}

	fridgeQuest();
	for(num i = 0; i<curSessionGlobalVar.players.length;i++){
		var player = curSessionGlobalVar.players[i];
		var guardian = player.guardian;
		player.relationships = [];
		guardian.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(curSessionGlobalVar.players);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}


}




void session0(){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i>curSessionGlobalVar.players.length){
			print("blank player");
			player = blankPlayerNoDerived(curSessionGlobalVar);
			guardian = blankPlayerNoDerived(curSessionGlobalVar);
			player.guardian = guardian;
			guardian.guardian = player;
			player.initialize();
            guardian.initialize();
			curSessionGlobalVar.players.add(player);
		}
	}

	aradiaQuest();
	for(num i = 0; i<curSessionGlobalVar.players.length;i++){
		Player player = curSessionGlobalVar.players[i];
		Player  guardian = player.guardian;
		player.relationships = [];
		guardian.relationships = [];
		List<Player> guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(curSessionGlobalVar.players);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}


}



//12 dead nepetas
void session33(){
	//will it be 12 nepetas roleplaying as their friends?
	//or 12 canon trolls all roleplaying as nepeta?
	//it's shrodinger's nepeta!!!
	session612();

	nepetaQuest();

}



//can't control HOW the session will turn out, but can at least give it the right players.
void session613(){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			player.initialize();
            guardian.initialize();
			guardian.quirk = randomTrollSim(curSessionGlobalVar.rand, guardian);
			player.quirk = randomTrollSim(curSessionGlobalVar.rand,player);
			//curSessionGlobalVar.guardians.add(guardian);
			curSessionGlobalVar.players.add(player);
			player.guardian = guardian;
			guardian.guardian = player;
		}
	}

	for(int i = 0; i<12; i++){
		Player player = curSessionGlobalVar.players[i];
		Player guardian = player.guardian;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(curSessionGlobalVar.players);
		session612IndexToTrollAncestor(player, i);
		session612IndexToTroll(guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}



//can't control HOW the session will turn out, but can at least give it the right players.
void session612(){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			player.initialize();
            guardian.initialize();
			guardian.quirk = randomTrollSim(curSessionGlobalVar.rand,guardian);
			player.quirk = randomTrollSim(curSessionGlobalVar.rand,player);
			//curSessionGlobalVar.guardians.add(guardian);
			curSessionGlobalVar.players.add(player);
			player.guardian = guardian;
			guardian.guardian = player;
		}
	}

	for(int i = 0; i<12; i++){
		Player player = curSessionGlobalVar.players[i];
		Player guardian = player.guardian;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(curSessionGlobalVar.players);
		session612IndexToTroll(player, i);
		session612IndexToTrollAncestor(guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}


//["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"]
//karkat, terezi, gamzee, equius, aradia, nepeta, tavros, vriska, kanaya, eridan, feferi, sollux
void session612IndexToTroll(player, index){
	player.hairColor = "#000000";
	player.isTroll = true;
	player.deriveChatHandle = false;
	if(index == 0){
		player.aspect = "Blood";
		player.moon = "Prospit";
		player.bloodColor = "#ff0000";
		player.land = "Land of Pulse and Haze";
		player.class_name = "Knight";
		player.hair = 29;
		player.leftHorn = 21;
		player.rightHorn = 21;
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.kernel_sprite = "Crab";
		player.interest1 = "Romance";
		player.interest2 = "Leadership";
		player.chatHandle = "carcinoGeneticist";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Limeade Refreshment", 1);
		f.effects.add(new FraymotifEffect("sanity",1,false));
		f.effects.add(new FraymotifEffect("sanity",1,true));
		f.flavorText = " All allies just settle their shit for a little while. Cool it. ";
		player.fraymotifs.add(f);
	}else if(index == 1){
		player.moon = "Prospit";
		player.aspect = "Mind";
		player.land = "Land of Thought and Flow";
		player.class_name = "Seer";
		player.hair = 10;
		player.leftHorn = 46;
		player.rightHorn = 46;
		player.bloodColor = "#008282";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 4;
		player.quirk.lettersToReplace = [["E","3"],["I","1"],["A","4"],[":\\)", ">: ]"]];
		player.quirk.lettersToReplaceIgnoreCase = [["E","3"],["I","1"],["A","4"]];
		player.kernel_sprite = "Dragon";
		player.interest1 = "Justice";
		player.interest2 = "Live Action Roleplaying";
		player.chatHandle = "gallowsCalibrator";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 2){
		player.moon = "Prospit";
		player.aspect = "Rage";
		player.land = "Land of Mirth and Tents";
		player.class_name = "Bard";
		player.hair = 41;
		player.leftHorn = 29;
		player.rightHorn = 29;
		player.bloodColor = "#631db4";
		player.quirk.capitalization = 4;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","motherfuck"],[":\\)", ":o)"]];
		player.kernel_sprite = "Seagoat";
		player.interest1 = "Clowns";
		player.interest2 = "Religion";
		player.chatHandle = "terminallyCapricious";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Chucklevoodoos", 1);
		f.effects.add(new FraymotifEffect("sanity",3,false));
		f.effects.add(new FraymotifEffect("sanity",3,true));
		f.flavorText = " Oh god oh no no no no no no no no. The enemies are no longer doing okay, psychologically speaking. ";
		player.fraymotifs.add(f);
	}else if(index == 3){
		player.moon = "Derse";
		player.land = "Land of Caves and Silence";
		player.aspect = "Void";
		player.class_name = "Heir";
		player.hair = 8;
		player.leftHorn = 43;
		player.rightHorn = 43;
		player.bloodColor = "#0021cb";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 6;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["x","%"],["fuck","fiddlesticks"]];
		player.quirk.prefix = "D -->";
		player.quirk.suffix = "";
		player.kernel_sprite = "Centaur";
		player.interest1 = "Classism";
		player.interest2 = "Weight Lifting";
		player.chatHandle = "centaursTesticle";

	}else if(index == 4){
		player.moon = "Derse";
		player.aspect = "Time";
		player.class_name = "Maid";
		player.land = "Land of Quartz and Melody";
		player.hair = 40;
		player.leftHorn = 36;
		player.rightHorn = 36;
		player.bloodColor = "#A10000";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","0"]];
		player.kernel_sprite = "Frog";
		player.interest1 = "Archaeology";
		player.interest2 = "Death";
    Random rand = new Random(curSessionGlobalVar.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random

    if(rand.nextDouble() > 0.6){
			player.robot = true; //not all aradias are robo aradias.
			player.bloodColor = "#0021cb"; //b100 blood
			player.hairColor = "#313131";
		}
		if(rand.nextDouble() > 0.6) player.dead = true; //not all aradias are ghost aradias.
		player.chatHandle = "apocalypseArisen";
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Telekinisis", 1);
		f.effects.add(new FraymotifEffect("power",2,true));
		f.flavorText = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif([],  "Ghost Communing", 1);
		f.effects.add(new FraymotifEffect("sanity",3,true));
		f.effects.add(new FraymotifEffect("sanity",3,false));
		f.flavorText = " The souls of the dead start hassling all enemies. ";
		player.fraymotifs.add(f);

	}else if(index == 5){
		player.moon = "Derse";
		player.aspect = "Heart";
		player.land = "Land of Little Cubes and Tea";
		player.class_name = "Rogue";
		player.hair = 7;
		player.leftHorn = 22;
		player.rightHorn = 22;
		player.bloodColor = "#416600";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ee","33"], ["per","purr"]];
		player.kernel_sprite = "Meowbeast";
		player.interest1 = "Role Playing";
		player.interest2 = "Romance";
		player.chatHandle = "arsenicCatnip";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 6){
		player.moon = "Prospit";
		player.aspect = "Breath";
		player.land = "Land of Sand and Zephyr";
		player.class_name = "Page";
		player.hair = 42;
		player.leftHorn = 28;
		player.rightHorn = 28;
		player.bloodColor = "#a25203";
		player.quirk.favoriteNumber = 1;
		player.quirk.capitalization = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","um"]];
		player.kernel_sprite = "Fairy Bull";
		player.interest1 = "Faeries";
		player.interest2 = "Animals";
		player.chatHandle = "adiosToreador";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Animal Communing", 1);
		f.effects.add(new FraymotifEffect("sanity",3,true));
		f.effects.add(new FraymotifEffect("sanity",3,false));
		f.flavorText = " Local animal equivalents start hassling all enemies. ";
		player.fraymotifs.add(f);
	}else if(index == 7){
		player.moon = "Prospit";
		player.land = "Land of Maps and Treasure";
		player.aspect = "Light";
		player.class_name = "Thief";
		player.hair = 14;
		player.leftHorn = 27;
		player.rightHorn = 27;
		player.bloodColor = "#004182";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.favoriteNumber = 8;
		player.quirk.lettersToReplaceIgnoreCase = [["b","8"]];
		player.interest1 = "Treasure";
		player.interest2 = "Live Action Roleplaying";
		player.kernel_sprite = "Spider";
		player.chatHandle = "arachnidsGrip";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		player.godDestiny = true;
		var f = new Fraymotif([],  "Mind Control", 1);
		f.effects.add(new FraymotifEffect("freeWill",3,true));
		f.effects.add(new FraymotifEffect("freeWill",3,false));
		f.flavorText = " All enemies start damaging themselves. It's kind of embarassing how easy this is.  ";
		player.fraymotifs.add(f);

	}else if(index == 8){
		player.moon = "Prospit";
		player.land = "Land of Rays and Frogs";
		player.aspect = "Space";
		player.class_name = "Sylph";
		player.hair = 39;
		player.leftHorn = 26;
		player.rightHorn = 26;
		player.bloodColor = "#078446";
		player.quirk.capitalization = 3;
		player.quirk.favoriteNumber = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.kernel_sprite = "Mother Grub";
		player.interest1 = "Vampires";
		player.interest2 = "Fashion";
		player.chatHandle = "grimAuxiliatrix";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 9){
		player.moon = "Derse";
		player.land = "Land of Wrath and Angels";
		player.aspect = "Hope";
		player.class_name = "Prince";
		player.hair = 6;
		player.leftHorn = 19;
		player.rightHorn = 19;
		player.bloodColor = "#610061";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 7;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"], ["v","vv"], ["w","ww"]];
		player.kernel_sprite = "Skyhorse";
		player.interest1 = "Genocide";
		player.interest2 = "History";
		player.chatHandle = "caligulasAquarium";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 10){
		player.moon = "Derse";
		player.land = "Land of Dew and Glass";
		player.aspect = "Life";
		player.class_name = "Witch";
		player.hair = 19;
		player.leftHorn = 35;
		player.rightHorn = 35;
		player.bloodColor = "#99004d";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 9;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["h",")("],["e","-E"], ["fuck","glub"],  ["god","cod"]];
		player.kernel_sprite = "Horrorterror";
		player.interest1 = "Animals";
		player.interest2 = "Social Justice";
		player.chatHandle = "cuttlefishCuller";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 11){
		player.moon = "Derse";//no way to have two dream selves righ tnow.;
		player.land = "Land of Brains and Fire";
		player.aspect = "Doom";
		player.class_name = "Mage";
		player.hair = 2;
		player.leftHorn = 33;
		player.rightHorn = 33;
		player.bloodColor = "#a1a100";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","ii"],["s","2"]];
		player.kernel_sprite = "Bicyclops";
		player.interest1 = "Hacking";
		player.interest2 = "Programming";
		player.chatHandle = "twinArmageddons";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		Fraymotif f = new Fraymotif([],  "Telekinisis", 1);
		f.effects.add(new FraymotifEffect("power",2,true));
		f.flavorText = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif([],  "Optic Blast", 1);
		f.effects.add(new FraymotifEffect("power",2,true));
		f.flavorText = " Red and blue eye beams pierce the ENEMY. ";
		player.fraymotifs.add(f);
	}
}



void session612IndexToTrollAncestor(player, index){
	player.hairColor = "#000000";
	player.isTroll = true;
	player.deriveChatHandle = false;
	if(index == 0){
		player.moon = "Prospit";
		player.aspect = "Blood";
		player.bloodColor = "#ff0000";
		player.land = "Land of Pulse and Haze";
		player.class_name = "Seer";
		player.hair = 44;
		player.leftHorn = 21;
		player.rightHorn = 21;
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["oo","69"], ["b","6"],["o","9"], ["fuck", "problematic"]];
		player.kernel_sprite = "Crab";
		player.interest1 = "Social Justice";
		player.interest2 = "Leadership";
		player.chatHandle = "carcinoGeneticist";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Limeade Refreshment", 1);
		f.effects.add(new FraymotifEffect("sanity",1,false));
		f.effects.add(new FraymotifEffect("sanity",1,true));
		f.flavorText = " All allies just settle their shit for a little while. Cool it. ";
		player.fraymotifs.add(f);
	}else if(index == 1){
		player.moon = "Prospit";
		player.land = "Land of Thought and Flow";
		player.aspect = "Mind";
		player.class_name = "Knight";
		player.hair = 47;
		player.leftHorn = 46;
		player.rightHorn = 46;
		player.bloodColor = "#008282";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 4;
		player.quirk.lettersToReplace = [["e","3"],["i","1"],["a","4"],["for","4"],["four","4"],["fore","4"],["E","3"],["I","1"],["A","4"],["s\\b", "z"],["S\\b", "Z"]];
		player.kernel_sprite = "Dragon";
		player.interest1 = "Justice";
		player.interest2 = "Video Games";
		player.chatHandle = "gallowsCalibrator";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 2){
		player.moon = "Prospit";
		player.land = "Land of Mirth and Tents";
		player.aspect = "Rage";
		player.class_name = "Prince";
		player.hair = 45;
		player.leftHorn = 29;
		player.rightHorn = 29;
		player.bloodColor = "#631db4";
		player.quirk.capitalization = 4;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","motherfuck"],[":\\)", ":o)"]];
		player.kernel_sprite = "Seagoat";
		player.interest1 = "Death";
		player.interest2 = "Religion";
		player.chatHandle = "terminallyCapricious";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Chucklevoodoos", 1);
		f.effects.add(new FraymotifEffect("sanity",3,false));
		f.effects.add(new FraymotifEffect("sanity",3,true));
		f.flavorText = " Oh god oh no no no no no no no no. The enemies are no longer doing okay, psychologically speaking. ";
		player.fraymotifs.add(f);
	}else if(index == 3){
		player.moon = "Derse";
		player.aspect = "Void";
		player.land = "Land of Caves and Silence";
		player.class_name = "Page";
		player.hair = 53;
		player.leftHorn = 43;
		player.rightHorn = 43;
		player.bloodColor = "#0021cb";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 6;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["x","%"],["fuck","fiddlesticks"]];
		player.quirk.prefix = "8==D";
		player.quirk.suffix = "";
		player.kernel_sprite = "Centaur";
		player.interest1 = "Animals";
		player.interest2 = "Weight Lifting";
		player.chatHandle = "centaursTesticle";
	}else if(index == 4){
		player.moon = "Derse";
		player.aspect = "Time";
		player.class_name = "Witch";
		player.land = "Land of Quartz and Melody";
		player.hair = 50;
		player.leftHorn = 36;
		player.rightHorn = 36;
		player.bloodColor = "#A10000";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["\\b[a-z]*\\b","私"]];
		player.kernel_sprite = "Frog";
		player.interest1 = "Intimidation";
		player.interest2 = "Death";
		player.chatHandle = "apocalypseArisen";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Telekinisis", 1);
		f.effects.add(new FraymotifEffect("power",2,true));
		f.flavorText = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif([],  "Ghost Communing", 1);
		f.effects.add(new FraymotifEffect("sanity",3,true));
		f.effects.add(new FraymotifEffect("sanity",3,false));
		f.flavorText = " The souls of the dead start hassling all enemies. ";
		player.fraymotifs.add(f);
	}else if(index == 5){
		player.aspect = "Heart";
		player.moon = "Derse";
		player.class_name = "Mage";
		player.land = "Land of Little Cubes and Tea";
		player.hair = 51;
		player.leftHorn = 22;
		player.rightHorn = 22;
		player.bloodColor = "#416600";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ee","33"]];
		player.kernel_sprite = "Meowbeast";
		player.interest1 = "TV";
		player.interest2 = "Romance";
		player.chatHandle = "arsenicCatnip";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 6){
		player.aspect = "Breath";
		player.moon = "Prospit";
		player.land = "Land of Sand and Zephyr";
		player.class_name = "Rogue";
		player.hair = 254;
		player.leftHorn = 28;
		player.rightHorn = 28;
		player.bloodColor = "#a25203";
		player.quirk.favoriteNumber = 1;
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","1"]];
		player.quirk.suffix = "";
		player.kernel_sprite = "Fairy Bull";
		player.interest1 = "Movies";
		player.interest2 = "Animals";
		player.chatHandle = "adiosToreador";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Animal Communing", 1);
		f.effects.add(new FraymotifEffect("sanity",3,true));
		f.effects.add(new FraymotifEffect("sanity",3,false));
		f.flavorText = " Local animal equivalents start hassling all enemies. ";
		player.fraymotifs.add(f);
	}else if(index == 7){
		player.aspect = "Light";
		player.moon = "Prospit";
		player.land = "Land of Maps and Treasure";
		player.class_name = "Sylph";
		player.hair = 52;
		player.leftHorn = 27;
		player.rightHorn = 27;
		player.bloodColor = "#004182";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.favoriteNumber = 8;
		player.quirk.lettersToReplaceIgnoreCase = [["b","8"]];
		player.interest1 = "Writing";
		player.interest2 = "Live Action Roleplaying";
		player.kernel_sprite = "Spider";
		player.chatHandle = "arachnidsGrip";
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Mind Control", 1);
		f.effects.add(new FraymotifEffect("freeWill",3,true));
		f.effects.add(new FraymotifEffect("freeWill",3,false));
		f.flavorText = " All enemies start damaging themselves. It's kind of embarassing how easy this is.  ";
		player.fraymotifs.add(f);

	}else if(index == 8){
		player.aspect = "Space";
		player.moon = "Prospit";
		player.land = "Land of Frost and Frogs";
		player.class_name = "Maid";
		player.hair = 55;
		player.leftHorn = 26;
		player.rightHorn = 26;
		player.bloodColor = "#078446";
		player.quirk.capitalization = 1;
		player.quirk.favoriteNumber = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","o+"]];
		player.kernel_sprite = "Mother Grub";
		player.interest1 = "Love";
		player.interest2 = "Fashion";
		player.chatHandle = "grimAuxiliatrix";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 9){
		player.aspect = "Hope";
		player.moon = "Derse";
		player.land = "Land of Wrath and Angels";
		player.class_name = "Bard";
		player.hair = 56;
		player.leftHorn = 19;
		player.rightHorn = 19;
		player.bloodColor = "#610061";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.favoriteNumber = 7;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"], ["v","vw"], ["w","wv"]];
		player.kernel_sprite = "Skyhorse";
		player.interest1 = "Romance";
		player.interest2 = "History";
		player.chatHandle = "caligulasAquarium";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 10){
		player.moon = "Derse";
		player.aspect = "Life";
		player.land = "Land of Dew and Glass";
		player.class_name = "Thief";
		player.hair = 57;
		player.leftHorn = 35;
		player.rightHorn = 35;
		player.bloodColor = "#99004d";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 9;
		player.quirk.lettersToReplace = [ ["H",")("],];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"],["e","-E"], ["fuck","glub"],  ["god","cod"]];
		player.kernel_sprite = "Horrorterror";
		player.interest1 = "Animals";
		player.interest2 = "Money";
		player.chatHandle = "cuttlefishCuller";
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 11){
		player.aspect = "Doom";
		player.moon = "Derse";
		player.land = "Land of Brains and Fire";
		player.class_name = "Heir";
		player.hair = 48;
		player.leftHorn = 33;
		player.rightHorn = 33;
		player.bloodColor = "#a1a100";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["E","3"],["S","5"],["O","0"],["S","2"],["T","7"],["I","1"],["B","8"]]; // E=3, A=4, S=5, O=0, T=7, I=1 and B=8.;
		player.kernel_sprite = "Bicyclops";
		player.interest1 = "Video Games";
		player.interest2 = "Programming";
		player.chatHandle = "twinArmageddons";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif([],  "Telekinisis", 1);
		f.effects.add(new FraymotifEffect("power",2,true));
		f.flavorText = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif([],  "Optic Blast", 1);
		f.effects.add(new FraymotifEffect("power",2,true));
		f.flavorText = " Red and blue eye beams pierce the ENEMY. ";
		player.fraymotifs.add(f);
	}
}



void session1025(){
	for(int i = 0; i<12; i++){
		Player  player;
		Player  guardian;
		if(i<curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			guardian = randomPlayerNoDerived(curSessionGlobalVar,"Page", "Void");
			guardian.quirk = randomTrollSim(curSessionGlobalVar.rand, guardian);
			player.quirk = randomTrollSim(curSessionGlobalVar.rand,player);
			//curSessionGlobalVar.guardians.add(guardian);
			player.guardian = guardian;
			guardian.guardian = player;
			curSessionGlobalVar.players.add(player);
		}
	}

	for(int i = 0; i<12; i++){
		Player player = curSessionGlobalVar.players[i];
		Player  guardian = player.guardian;
		if(i<8){
			session413IndexToHuman(player,i);
			session413IndexToAncestor(guardian,i);
		}else{
			num index = 0;
			if(i == 8){
				index = 0;
			}else if(i == 9){
				index = 8;
			}else if(i == 10){
				index = 1;
			}else if(i == 11){
				index = 7;
			}
			session612IndexToTroll(player, index);
			session612IndexToTroll(guardian, index);
		}
		var guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateRelationships(guardians);
		player.relationships = [];
		player.generateRelationships(curSessionGlobalVar.players);

		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}

}
