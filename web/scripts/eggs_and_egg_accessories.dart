import "dart:async";
import "dart:html";

import "SBURBSim.dart";
import 'navbar.dart';

void bardQuestMode(){
	if(window.confirm("Behold the Majesty of the CodTier? Y/N")){
		bardQuest = true;
	}else{
		window.alert("But thou must!");
		bardQuestMode();
	}

}

///takes in a strin gparam from url
/////example of use ?canonState=everythingFuckingGoes
///warning, fanonOnly will basically crash if there isn't at least #OfPlayers amount of fanon classes and aspects. i don't recomend using it yet.
void changeCanonState(String state) {
	//CanonLevel
	if(state == "canonOnly") curSessionGlobalVar.canonLevel = CanonLevel.CANON_ONLY;
	if(state == "fanonOnly") curSessionGlobalVar.canonLevel = CanonLevel.FANON_ONLY;
	if(state == "everythingFuckingGoes") curSessionGlobalVar.canonLevel = CanonLevel.EVERYTHING_FUCKING_GOES;

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
		Player p = curSessionGlobalVar.players[j];
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
	}else if(curSessionGlobalVar.session_id == 13){ //wait, why is THIRTEEN an arc number ???
		session13();
	}

	if(getParameterByName("images",null)  == "pumpkin"){
		doNotRender = true;
	}

	if(getParameterByName("easter",null)  == "egg"){
		easter_egg = true;
		window.alert("Yo Dawg, I herd you liek easter eggs???");
	}


	if(getParameterByName("selfInsertOC",null)  == "true"){
		//print("Self Insert OC was true, so I'm going hunting for what ocs I want");
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
	if(window.location.search.isEmpty && simulatedParamsGlobalVar.isEmpty) {
	  //print("no params to look at");
		return;
	}
	String params1 = null;
	if(window.location.search.isNotEmpty) params1 = window.location.search.substring(1);
	String params2 = simulatedParamsGlobalVar;
	//print("~~~~~~params1 is $params1 ~~~~~~and~~~~~~params2 is $params2");
	List<String> tmp = SBURBClassManager.allClassNames;
	List<String> all_aspects =  Aspects.names.toList();
	String params = "";
	if(params1 != null){
		params = params1;
		if(params2!= null){
			params += "&" + params2;
		}
	}else if(params2 != null) params = params2;
	List<String> paramsArray = params.split("&");
	for(num i = 0; i<paramsArray.length; i++){
		List<String> stuck = paramsArray[i].split("Stuck");
		//print("stuck is: " + stuck.toString());
		if(stuck.length == 2){
			if(tmp.indexOf(stuck[0]) != -1){
				setAllClassesTo(stuck[0].trim());
			}else if(all_aspects.indexOf(stuck[0]) != -1){
				setAllAspectsTo(stuck[0].trim());
			}
		}
	}

}



void setAllAspectsTo(String a){
	//print("Setting all aspects to: $a");
	Aspect aspect = Aspects.stringToAspect(a);
	for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		if(curSessionGlobalVar.players[i].aspect != Aspects.TIME && curSessionGlobalVar.players[i].aspect != Aspects.SPACE ) curSessionGlobalVar.players[i].aspect = aspect; //You can have no space/time in your own sessions, but AB will never do it on purpose.
		if(curSessionGlobalVar.players[i].guardian.aspect != Aspects.TIME && curSessionGlobalVar.players[i].guardian.aspect != Aspects.SPACE ) curSessionGlobalVar.players[i].guardian.aspect = aspect;
	}
}



void setAllClassesTo(String c){
	//print("Setting all classes to: $c");
	SBURBClass class_name = SBURBClassManager.stringToSBURBClass(c);
	for(num i = 0; i<curSessionGlobalVar.players.length; i++){
		curSessionGlobalVar.players[i].class_name = class_name;
		curSessionGlobalVar.players[i].guardian.class_name = class_name;
	}
}



void processFanOCs(callBack, that){
	//print("making a new easte egg engine");
	//start up an easterEggEngine.
	new CharacterEasterEggEngine().loadArraysFromFile(callBack,true,that); //<-- ASYNCHRONOUS, so MUST END HERE. any future steps should be in the easterEggEngine itself.
}






void babyStuckMode(){
	if(!doNotRender) window.alert("goo goo GA GAH!");
	for(num j = 0; j<curSessionGlobalVar.players.length; j++){
		Player p = curSessionGlobalVar.players[j];
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
		p.addStat(Stats.POWER,20); //Robots are superior.
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
	if(!doNotRender &&  querySelector("#avatar") != null) (querySelector("#avatar") as ImageElement).src = "images/CandyAuthorBot.png";
	appendHtml(querySelector("#story"),"<img src = 'images/trickster_author.png' style='float:left;'><img src = 'images/trickster_artist.png' style='float:left;'>");
	querySelector('body').style.backgroundImage =  "url(images/zilly.gif)"; //.style.backgroundColor
	querySelector('#story').style.backgroundColor ="#ff93e4";
	for(num j = 0; j<curSessionGlobalVar.players.length; j++){
		var p = curSessionGlobalVar.players[j];
		if(p.aspect != Aspects.DOOM){ //kr says it would be funny if doom plalyers completely immune.
			p.hairColor = curSessionGlobalVar.rand.pickFrom(tricksterColors).toStyleString();
			p.bloodColor = curSessionGlobalVar.rand.pickFrom(tricksterColors).toStyleString();
			p.trickster  = true;
		}else{
		}


		if(p.aspect != Aspects.HEART && p.aspect != Aspects.DOOM){//no personality changes.
			p.quirk.capitalization = 2;
			p.quirk.punctuation = 3;
			p.quirk.favoriteNumber = 11;
			for(num k = 0; k <p.relationships.length; k++){
				var r = p.relationships[k];
				r.value = 111111; //EVERYTHIGN IS BETTER!!!!!!!!!!!
			}
		}
		if(p.aspect != Aspects.DOOM){
			p.setStat(Stats.POWER,  111111);
			p.landLevel = 111111.0;
			p.grist = 11111111111;
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
		p.addStat(Stats.SANITY,-10);
		p.decideLusus();
		p.hairColor = "#000000";
		p.object_to_prototype = p.myLusus;
		p.relationships = [];
		p.quirk = null;
		p.generateRelationships(curSessionGlobalVar.players);  //heiresses hate each other
		p.quirk = randomTrollSim(curSessionGlobalVar.rand, p);
	}
}


void session413(){
	//print("413");
	for(int i = 0; i<8; i++){
		Player player;
		Player guardian;
		if(i< curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
			//print("using existing player");
		}else{
			//print("making new player");
			player = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
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
	curSessionGlobalVar.players.length = 8; //no more, no less.
}



void session111111(){
	for(int i = 0; i<8; i++){
		Player  player;
		Player guardian;
		if(i< curSessionGlobalVar.players.length){
			player = curSessionGlobalVar.players[i];
		}else{
			player = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
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
		List<Player> guardians = getGuardiansForPlayers(curSessionGlobalVar.players);
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(curSessionGlobalVar.players);
		session413IndexToAncestor(player, i);
		session413IndexToHuman(guardian, i);//just call regular with a different index
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
	curSessionGlobalVar.players.length = 8; //no more, no less.
}



void session413IndexToHuman(Player player, int index){
	player.isTroll = false;
	player.deriveChatHandle = false;
    player.deriveLand = false;
	if(index == 0){
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.HEIR;
		player.godDestiny = true;
		player.aspect = Aspects.BREATH;
		player.hair  =3;
		player.hairColor = "#000000";
		player.chatHandle = "ectoBiologist";
		player.interest1 = new Interest("Pranks", InterestManager.COMEDY);
		player.interest2 = new Interest("Action Movies", InterestManager.POPCULTURE);
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
		player.class_name = SBURBClassManager.SEER;
		player.land = "Land of Light and Rain";
		player.aspect = Aspects.LIGHT;
		player.chatHandle = "tentacleTherapist";
		player.interest1 = new Interest("Writing", InterestManager.WRITING);
		player.interest2 = new Interest("HorrorTerrors", InterestManager.FANTASY);
		player.hair  =20;
		player.hairColor = "#fff3bd";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["hey","greetings"],["yes", "certainly"]];
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 2){
		player.moon = "Derse";
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.KNIGHT;
		player.land = "Land of Heat and Clockwork";
		player.aspect = Aspects.TIME;
		player.hairColor = "#feffd7";
		player.hair  =1;
		player.chatHandle = "turntechGodhead";
		player.interest1 = new Interest("Rap", InterestManager.MUSIC);
		player.interest2 = new Interest("Irony", InterestManager.POPCULTURE);
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
		player.class_name = SBURBClassManager.WITCH;
		player.land = "Land of Frost and Frogs";
		player.aspect = Aspects.SPACE;
		player.hair  =9;
		player.hairColor = "#3f1904";
		player.chatHandle = "gardenGnostic";
		player.interest1 = new Interest("Physics", InterestManager.ACADEMIC);
		player.interest2 = new Interest("Gardening", InterestManager.DOMESTIC);
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 3;
		player.quirk.favoriteNumber = 5;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 4){
		player.moon = "Prospit";
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.MAID;
		player.godDestiny = true;
		player.aspect = Aspects.LIFE;
		player.land = "Land of Crypts and Helium";
		player.hair  =38;
		player.hairColor = "#000000";
		player.chatHandle = "gutsyGumshoe";
		player.interest1 = new Interest("Pranks", InterestManager.COMEDY);
		player.interest2 = new Interest("Baking", InterestManager.DOMESTIC);
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["lol","hoo hoo"]];
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 5){
		player.moon = "Derse";
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.ROGUE;
		player.land = "Land of Pyramids and Neon";
		player.aspect = Aspects.VOID;
		player.hair  =24;
		player.hairColor = "#fff3bd";
		player.chatHandle = "tipsyGnostalgic";
		player.interest1 = new Interest("Writing", InterestManager.WRITING);
		player.interest2 = new Interest("Wizards", InterestManager.FANTASY);
		//HI!!! HOW ARE YOU!?
		player.quirk.capitalization = 0;
		player.quirk.punctuation = 0;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["like","liek"], ["school","skool"]];
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 6){
		player.moon = "Derse";
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.PRINCE;
		player.land = "Land of Tombs and Krypton";
		player.aspect = Aspects.HEART;
		player.hair  =36;
		player.hairColor = "#feffd7";
		player.chatHandle = "timaeusTestified";
		player.interest1 = new Interest("Irony", InterestManager.POPCULTURE);
		player.interest2 = new Interest("Writing", InterestManager.WRITING);
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
		player.class_name = SBURBClassManager.PAGE;
		player.land = "Land of Mounds and Xenon";
		player.aspect = Aspects.HOPE;
		player.hair  =37;
		player.hairColor = "#3f1904";
		player.chatHandle = "golgothasTerror";
		player.interest1 = new Interest("Physics", InterestManager.ACADEMIC);
		player.interest2 = new Interest("Movies", InterestManager.POPCULTURE);
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
void session413IndexToAncestor(Player player, int index){
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
		if(p.aspect == Aspects.TIME){
			session413IndexToHuman(p,2);
			session413IndexToAncestor(g,2);
		}else if(p.aspect == Aspects.SPACE){
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
		if(p.aspect == Aspects.TIME){
			session612IndexToTroll(p,4);
			session612IndexToTrollAncestor(g,4);
		}else if(p.aspect == Aspects.SPACE){
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
		if(p.aspect == Aspects.TIME){
			session612IndexToTroll(g,4);
			session612IndexToTrollAncestor(p,4);
		}else if(p.aspect == Aspects.SPACE){
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
		if(p.aspect == Aspects.TIME){
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
		}else if(p.aspect == Aspects.SPACE){
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
	if(p.aspect != Aspects.TIME && p.aspect != Aspects.SPACE){
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
		if(actualRandomNumber > .5 && player.aspect != Aspects.TIME && player.aspect != Aspects.SPACE){ //just cause they are roleplaying as nepeta doesn't mean their claspect changes.
			player.aspect = Aspects.HEART;
		}
		player.class_name = SBURBClassManager.ROGUE;
		if(guardian.aspect != Aspects.TIME && guardian.aspect != Aspects.SPACE){
			guardian.aspect = Aspects.HEART;

		}
		guardian.class_name = SBURBClassManager.ROGUE;
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
			player.aspect = Aspects.SPACE;
			guardian.aspect = Aspects.SPACE;
		}else if(i == 1){
			player.aspect = Aspects.TIME;
			guardian.aspect = Aspects.TIME;
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
			player.aspect == Aspects.SPACE;
			guardian.aspect == Aspects.SPACE;
		}else if(i == 1){
			player.aspect == Aspects.TIME;
			guardian.aspect == Aspects.TIME;
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
			//print("blank player");
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

//what even is this???
void session13() {
    curSessionGlobalVar.mutator.metaHandler.initalizePlayers(curSessionGlobalVar);
	curSessionGlobalVar.players = curSessionGlobalVar.mutator.metaHandler.metaPlayers; //just blow them away.
    print("players is: ${curSessionGlobalVar.players}");
    curSessionGlobalVar.players[0].leader = true;
    for(Player p in curSessionGlobalVar.players) {
        p.ectoBiologicalSource = null; //can do ectobiology.
    }

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

void session0(){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i>curSessionGlobalVar.players.length){
			//print("blank player");
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
			player = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
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
			player = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
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
void session612IndexToTroll(Player player, int index){
	player.hairColor = "#000000";
	player.isTroll = true;
	player.deriveChatHandle = false;
	player.deriveLand = false;
	if(index == 0){
		player.aspect = Aspects.BLOOD;
		player.moon = "Prospit";
		player.bloodColor = "#ff0000";
		player.land = "Land of Pulse and Haze";
		player.class_name = SBURBClassManager.KNIGHT;
		player.hair = 29;
		player.leftHorn = 21;
		player.rightHorn = 21;
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.interest1 = new Interest("Romance", InterestManager.ROMANTIC);
		player.interest2 = new Interest("Leadership", InterestManager.SOCIAL);
		player.chatHandle = "carcinoGeneticist";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Limeade Refreshment", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,1,false));
		f.effects.add(new FraymotifEffect(Stats.SANITY,1,true));
		f.desc = " All allies just settle their shit for a little while. Cool it. ";
		player.fraymotifs.add(f);
	}else if(index == 1){
		player.moon = "Prospit";
		player.aspect = Aspects.MIND;
		player.land = "Land of Thought and Flow";
		player.class_name = SBURBClassManager.SEER;
		player.hair = 10;
		player.leftHorn = 46;
		player.rightHorn = 46;
		player.bloodColor = "#008282";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 4;
		player.quirk.lettersToReplace = [["E","3"],["I","1"],["A","4"],[":\\)", ">: ]"]];
		player.quirk.lettersToReplaceIgnoreCase = [["E","3"],["I","1"],["A","4"]];
		player.interest1 = new Interest("Justice", InterestManager.JUSTICE);
		player.interest2 = new Interest("Live Action Roleplaying", InterestManager.SOCIAL);
		player.chatHandle = "gallowsCalibrator";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 2){
		player.moon = "Prospit";
		player.aspect = Aspects.RAGE;
		player.land = "Land of Mirth and Tents";
		player.class_name = SBURBClassManager.BARD;
		player.hair = 41;
		player.leftHorn = 29;
		player.rightHorn = 29;
		player.bloodColor = "#631db4";
		player.quirk.capitalization = 4;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","motherfuck"],[":\\)", ":o)"]];
		player.interest1 =new Interest("Clowns", InterestManager.TERRIBLE);
		player.interest2 = new Interest("Religion", InterestManager.SOCIAL);
		player.chatHandle = "terminallyCapricious";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Chucklevoodoos", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,false));
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,true));
		f.desc = " Oh god oh no no no no no no no no. The enemies are no longer doing okay, psychologically speaking. ";
		player.fraymotifs.add(f);
	}else if(index == 3){
		player.moon = "Derse";
		player.land = "Land of Caves and Silence";
		player.aspect = Aspects.VOID;
		player.class_name = SBURBClassManager.HEIR;
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
		player.interest1 = new Interest("Classism", InterestManager.TERRIBLE);
		player.interest2 = new Interest("Weight Lifting", InterestManager.ATHLETIC);
		player.chatHandle = "centaursTesticle";

	}else if(index == 4){
		player.moon = "Derse";
		player.aspect = Aspects.TIME;
		player.class_name = SBURBClassManager.MAID;
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
		player.interest1 = new Interest("Archeology", InterestManager.ACADEMIC);
		player.interest2 = new Interest("Death", InterestManager.TERRIBLE);
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
		var f = new Fraymotif( "Telekinisis", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif( "Ghost Communing", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,true));
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,false));
		f.desc = " The souls of the dead start hassling all enemies. ";
		player.fraymotifs.add(f);

	}else if(index == 5){
		player.moon = "Derse";
		player.aspect = Aspects.HEART;
		player.land = "Land of Little Cubes and Tea";
		player.class_name = SBURBClassManager.ROGUE;
		player.hair = 7;
		player.leftHorn = 22;
		player.rightHorn = 22;
		player.bloodColor = "#416600";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ee","33"], ["per","purr"]];
		player.interest1 = new Interest("Role Playing", InterestManager.SOCIAL);
		player.interest2 = new Interest("Romance", InterestManager.ROMANTIC);
		player.chatHandle = "arsenicCatnip";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 6){
		player.moon = "Prospit";
		player.aspect = Aspects.BREATH;
		player.land = "Land of Sand and Zephyr";
		player.class_name = SBURBClassManager.PAGE;
		player.hair = 42;
		player.leftHorn = 28;
		player.rightHorn = 28;
		player.bloodColor = "#a25203";
		player.quirk.favoriteNumber = 1;
		player.quirk.capitalization = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","um"]];
		player.interest1 = new Interest("Fairies", InterestManager.FANTASY);
		player.interest2 = new Interest("Animals", InterestManager.SOCIAL);
		player.chatHandle = "adiosToreador";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Animal Communing", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,true));
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,false));
		f.desc = " Local animal equivalents start hassling all enemies. ";
		player.fraymotifs.add(f);
	}else if(index == 7){
		player.moon = "Prospit";
		player.land = "Land of Maps and Treasure";
		player.aspect = Aspects.LIGHT;
		player.class_name = SBURBClassManager.THIEF;
		player.hair = 14;
		player.leftHorn = 27;
		player.rightHorn = 27;
		player.bloodColor = "#004182";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 3;
		player.quirk.lettersToReplace = [];
		player.quirk.favoriteNumber = 8;
		player.quirk.lettersToReplaceIgnoreCase = [["b","8"]];
		player.interest1 = new Interest("Treasure", InterestManager.TERRIBLE);
		player.interest2 = new Interest("Life Action Roleplaying", InterestManager.SOCIAL);
		player.chatHandle = "arachnidsGrip";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		player.godDestiny = true;
		var f = new Fraymotif( "Mind Control", 1);
		f.effects.add(new FraymotifEffect(Stats.FREE_WILL,3,true));
		f.effects.add(new FraymotifEffect(Stats.FREE_WILL,3,false));
		f.desc = " All enemies start damaging themselves. It's kind of embarassing how easy this is.  ";
		player.fraymotifs.add(f);

	}else if(index == 8){
		player.moon = "Prospit";
		player.land = "Land of Rays and Frogs";
		player.aspect = Aspects.SPACE;
		player.class_name = SBURBClassManager.SYLPH;
		player.hair = 39;
		player.leftHorn = 26;
		player.rightHorn = 26;
		player.bloodColor = "#078446";
		player.quirk.capitalization = 3;
		player.quirk.favoriteNumber = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [];
		player.interest1 = new Interest("Vampires", InterestManager.FANTASY);
		player.interest2 = new Interest("Fashion", InterestManager.DOMESTIC);
		player.chatHandle = "grimAuxiliatrix";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 9){
		player.moon = "Derse";
		player.land = "Land of Wrath and Angels";
		player.aspect = Aspects.HOPE;
		player.class_name = SBURBClassManager.PRINCE;
		player.hair = 6;
		player.leftHorn = 19;
		player.rightHorn = 19;
		player.bloodColor = "#610061";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 7;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"], ["v","vv"], ["w","ww"]];
		player.interest1 = new Interest("Genocide", InterestManager.TERRIBLE);
		player.interest2 = new Interest("History", InterestManager.ACADEMIC);
		player.chatHandle = "caligulasAquarium";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 10){
		player.moon = "Derse";
		player.land = "Land of Dew and Glass";
		player.aspect = Aspects.LIFE;
		player.class_name = SBURBClassManager.WITCH;
		player.hair = 19;
		player.leftHorn = 35;
		player.rightHorn = 35;
		player.bloodColor = "#99004d";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 9;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["h",")("],["e","-E"], ["fuck","glub"],  ["god","cod"]];
		player.interest1 = new Interest("Animals", InterestManager.SOCIAL);
		player.interest2 = new Interest("Justice", InterestManager.JUSTICE);
		player.chatHandle = "cuttlefishCuller";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 11){
		player.moon = "Derse";//no way to have two dream selves righ tnow.;
		player.land = "Land of Brains and Fire";
		player.aspect = Aspects.DOOM;
		player.class_name = SBURBClassManager.MAGE;
		player.hair = 2;
		player.leftHorn = 33;
		player.rightHorn = 33;
		player.bloodColor = "#a1a100";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["i","ii"],["s","2"]];
		player.interest1 = new Interest("Hacking", InterestManager.TECHNOLOGY);
		player.interest2 = new Interest("Programming", InterestManager.TECHNOLOGY);
		player.chatHandle = "twinArmageddons";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		Fraymotif f = new Fraymotif( "Telekinisis", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif( "Optic Blast", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Red and blue eye beams pierce the ENEMY. ";
		player.fraymotifs.add(f);
	}
}



void session612IndexToTrollAncestor(Player player, index){
	player.hairColor = "#000000";
	player.isTroll = true;
	player.deriveChatHandle = false;
    player.deriveLand = false;
	if(index == 0){
		player.moon = "Prospit";
		player.aspect = Aspects.BLOOD;
		player.bloodColor = "#ff0000";
		player.land = "Land of Pulse and Haze";
		player.class_name = SBURBClassManager.SEER;
		player.hair = 44;
		player.leftHorn = 21;
		player.rightHorn = 21;
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["oo","69"], ["b","6"],["o","9"], ["fuck", "problematic"]];
		player.interest1 = new Interest("Social Justice", InterestManager.JUSTICE);
		player.interest2 = new Interest("Leadership", InterestManager.SOCIAL);
		player.chatHandle = "carcinoGeneticist";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Limeade Refreshment", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,1,false));
		f.effects.add(new FraymotifEffect(Stats.SANITY,1,true));
		f.desc = " All allies just settle their shit for a little while. Cool it. ";
		player.fraymotifs.add(f);
	}else if(index == 1){
		player.moon = "Prospit";
		player.land = "Land of Thought and Flow";
		player.aspect = Aspects.MIND;
		player.class_name = SBURBClassManager.KNIGHT;
		player.hair = 47;
		player.leftHorn = 46;
		player.rightHorn = 46;
		player.bloodColor = "#008282";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 4;
		player.quirk.lettersToReplace = [["e","3"],["i","1"],["a","4"],["for","4"],["four","4"],["fore","4"],["E","3"],["I","1"],["A","4"],["s\\b", "z"],["S\\b", "Z"]];
		player.interest1 = new Interest("Justice", InterestManager.JUSTICE);
		player.interest2 = new Interest("Video Games", InterestManager.POPCULTURE);
		player.chatHandle = "gallowsCalibrator";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 2){
		player.moon = "Prospit";
		player.land = "Land of Mirth and Tents";
		player.aspect = Aspects.RAGE;
		player.class_name = SBURBClassManager.PRINCE;
		player.hair = 45;
		player.leftHorn = 29;
		player.rightHorn = 29;
		player.bloodColor = "#631db4";
		player.quirk.capitalization = 4;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 10;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["fuck","motherfuck"],[":\\)", ":o)"]];
		player.interest1 = new Interest("Death", InterestManager.TERRIBLE);
		player.interest2 = new Interest("Religion", InterestManager.SOCIAL);
		player.chatHandle = "terminallyCapricious";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Chucklevoodoos", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,false));
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,true));
		f.desc = " Oh god oh no no no no no no no no. The enemies are no longer doing okay, psychologically speaking. ";
		player.fraymotifs.add(f);
	}else if(index == 3){
		player.moon = "Derse";
		player.aspect = Aspects.VOID;
		player.land = "Land of Caves and Silence";
		player.class_name = SBURBClassManager.PAGE;
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
		player.interest1 = new Interest("Animals", InterestManager.SOCIAL);
		player.interest2 = new Interest("Weight Lifting", InterestManager.ATHLETIC);
		player.chatHandle = "centaursTesticle";
	}else if(index == 4){
		player.moon = "Derse";
		player.aspect = Aspects.TIME;
		player.class_name = SBURBClassManager.WITCH;
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
		player.interest1 = new Interest("Intimidation", InterestManager.TERRIBLE);
		player.interest2 = new Interest("Death", InterestManager.TERRIBLE);
		player.chatHandle = "apocalypseArisen";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Telekinisis", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif( "Ghost Communing", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,true));
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,false));
		f.desc = " The souls of the dead start hassling all enemies. ";
		player.fraymotifs.add(f);
	}else if(index == 5){
		player.aspect = Aspects.HEART;
		player.moon = "Derse";
		player.class_name = SBURBClassManager.MAGE;
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
		player.interest1 = new Interest("Memes", InterestManager.POPCULTURE);
		player.interest2 = new Interest("Romance", InterestManager.ROMANTIC);
		player.chatHandle = "arsenicCatnip";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 6){
		player.aspect = Aspects.BREATH;
		player.moon = "Prospit";
		player.land = "Land of Sand and Zephyr";
		player.class_name = SBURBClassManager.ROGUE;
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
		player.interest1 = new Interest("Anime", InterestManager.POPCULTURE);
		player.interest2 = new Interest("Animals", InterestManager.SOCIAL);
		player.chatHandle = "adiosToreador";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Animal Communing", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,true));
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,false));
		f.desc = " Local animal equivalents start hassling all enemies. ";
		player.fraymotifs.add(f);
	}else if(index == 7){
		player.aspect = Aspects.LIGHT;
		player.moon = "Prospit";
		player.land = "Land of Maps and Treasure";
		player.class_name = SBURBClassManager.SYLPH;
		player.hair = 52;
		player.leftHorn = 27;
		player.rightHorn = 27;
		player.bloodColor = "#004182";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.favoriteNumber = 8;
		player.quirk.lettersToReplaceIgnoreCase = [["b","8"]];
		player.interest1 = new Interest("Writings", InterestManager.WRITING);
		player.interest2 = new Interest("Live Action Role-playing", InterestManager.SOCIAL);
		player.chatHandle = "arachnidsGrip";
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Mind Control", 1);
		f.effects.add(new FraymotifEffect(Stats.FREE_WILL,3,true));
		f.effects.add(new FraymotifEffect(Stats.FREE_WILL,3,false));
		f.desc = " All enemies start damaging themselves. It's kind of embarassing how easy this is.  ";
		player.fraymotifs.add(f);

	}else if(index == 8){
		player.aspect = Aspects.SPACE;
		player.moon = "Prospit";
		player.land = "Land of Frost and Frogs";
		player.class_name = SBURBClassManager.MAID;
		player.hair = 55;
		player.leftHorn = 26;
		player.rightHorn = 26;
		player.bloodColor = "#078446";
		player.quirk.capitalization = 1;
		player.quirk.favoriteNumber = 5;
		player.quirk.punctuation = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["o","o+"]];
		player.interest1 = new Interest("Love", InterestManager.ROMANTIC);
		player.interest2 = new Interest("Fashion", InterestManager.DOMESTIC);
		player.chatHandle = "grimAuxiliatrix";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 9){
		player.aspect = Aspects.HOPE;
		player.moon = "Derse";
		player.land = "Land of Wrath and Angels";
		player.class_name = SBURBClassManager.BARD;
		player.hair = 56;
		player.leftHorn = 19;
		player.rightHorn = 19;
		player.bloodColor = "#610061";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 1;
		player.quirk.favoriteNumber = 7;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"], ["v","vw"], ["w","wv"]];
		player.interest1 = new Interest("Romance", InterestManager.ROMANTIC);
		player.interest2 = new Interest("History", InterestManager.ACADEMIC);
		player.chatHandle = "caligulasAquarium";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 10){
		player.moon = "Derse";
		player.aspect = Aspects.LIFE;
		player.land = "Land of Dew and Glass";
		player.class_name = SBURBClassManager.THIEF;
		player.hair = 57;
		player.leftHorn = 35;
		player.rightHorn = 35;
		player.bloodColor = "#99004d";
		player.quirk.capitalization = 1;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 9;
		player.quirk.lettersToReplace = [ ["H",")("],];
		player.quirk.lettersToReplaceIgnoreCase = [["ing","in"],["e","-E"], ["fuck","glub"],  ["god","cod"]];
		player.interest1 = new Interest("Animals", InterestManager.SOCIAL);
		player.interest2 = new Interest("Money", InterestManager.TERRIBLE);
		player.chatHandle = "cuttlefishCuller";
		player.godDestiny = true;
		player.quirk.suffix = "";
		player.quirk.prefix = "";
	}else if(index == 11){
		player.aspect = Aspects.DOOM;
		player.moon = "Derse";
		player.land = "Land of Brains and Fire";
		player.class_name = SBURBClassManager.HEIR;
		player.hair = 48;
		player.leftHorn = 33;
		player.rightHorn = 33;
		player.bloodColor = "#a1a100";
		player.quirk.capitalization = 2;
		player.quirk.punctuation = 2;
		player.quirk.favoriteNumber = 2;
		player.quirk.lettersToReplace = [];
		player.quirk.lettersToReplaceIgnoreCase = [["E","3"],["S","5"],["O","0"],["S","2"],["T","7"],["I","1"],["B","8"]]; // E=3, A=4, S=5, O=0, T=7, I=1 and B=8.;
		player.interest1 = new Interest("Video Games", InterestManager.POPCULTURE);
		player.interest2 = new Interest("Programming", InterestManager.TECHNOLOGY);
		player.chatHandle = "twinArmageddons";
		player.quirk.suffix = "";
		player.quirk.prefix = "";
		var f = new Fraymotif( "Telekinisis", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif( "Optic Blast", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Red and blue eye beams pierce the ENEMY. ";
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
			player = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(curSessionGlobalVar,SBURBClassManager.PAGE, Aspects.VOID);
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
