import "dart:async";
import "dart:html";
import "NonCanonSessions.dart";

import "../SBURBSim.dart";
import '../navbar.dart';

void bardQuestMode(Session session){
	if(window.confirm("Behold the Majesty of the CodTier? Y/N")){
		bardQuest = true;
	}else{
		window.alert("But thou must!");
		bardQuestMode(session);
	}

}

///takes in a strin gparam from url
/////example of use ?canonState=everythingFuckingGoes
///warning, fanonOnly will basically crash if there isn't at least #OfPlayers amount of fanon classes and aspects. i don't recomend using it yet.
void changeCanonState(Session session,String state) {
	//CanonLevel
	if(state == "canonOnly") session.canonLevel = CanonLevel.CANON_ONLY;
	if(state == "fanonOnly") session.canonLevel = CanonLevel.FANON_ONLY;
	if(state == "everythingFuckingGoes") session.canonLevel = CanonLevel.EVERYTHING_FUCKING_GOES;

}


void faceOffMode(Session session){
	faceOff = true;
	window.alert("Wait...so...if this is 'face off' mode....does that mean the creepy flesh masks were their real faces all along, and THIS is what was hidden underneath???");
	for(num i = 0; i<session.players.length; i++){
		session.players[i].grimDark = 4;
	}
}



void pen15Ouija(Session session){
	ouija = true;
	window.alert("thats the spooky thing about penis ouija you can never be sure who did the dicks");
	window.alert("was it you or me or maybe a ghoooost???");
	querySelector('body').style.backgroundColor = "#f8c858";
	querySelector('body').style.backgroundImage = "url(images/pen15_bg1.png)";
}



void coolK1DMode(Session session){
	window.alert("H3Y TH3R3 COOL K1D 1S TH1S YOU???");
}



//no. you gots to flip it TURN-WAYS, dunkass.
//rendering shouldu be different
//making new scenes to be different
void sbahjMode(Session session){
	if(!doNotRender) window.alert("where MAKING THIS HAPEN");
	//when kr has their stuff read, render it after everything else is done , or just, like put it on a 30 second timer. needs comedic timing, needs to be on top
	//maybe my laughing reaction shot sbahj_author.jpg goes then, too
	appendHtml(SimController.instance.storyElement,"<img src = 'images/AUTHORSBAHJ.jpg' style='position:absolute; top:111px'><img src = 'images/sbahj_author.jpg' style='position:absolute; left:0px; z-index: 999;'>");


	new Timer(new Duration(milliseconds: 10000), () =>appendHtml(SimController.instance.storyElement,"<img src = 'images/kR_falls_DOWN_stairs_forever.gif' style='position:fixed; top:0px;; z-index: 999;'>"));

	querySelector('body').style.backgroundColor = "#0000ff";
	querySelector('body').style.backgroundImage = "none";
	querySelector('#story').style.backgroundColor = "#ff00ff";
	session.sbahj = true;
	for(num j = 0; j<session.players.length; j++){
		Player p = session.players[j];
		p.sbahj = true;
		p.quirk.lettersToReplaceIgnoreCase =sbahj_quirks;
	}
}



// 4/4/18 i'm trying to make this async instead of callback based so that AB will be saner.
 void checkEasterEgg(Session session){  //only yellow yard session uses 'that' because it needs to get back to the session context after doing easter egg.
	//authorMessage();
	//i cannot resist
	//easter egg ^_^
	if (getParameterByName("royalRumble", null) == "true") {
		debugRoyalRumble(session);
	}

	if (getParameterByName("COOLK1D", null) == "true") {
		cool_kid = true;
		coolK1DMode(session);
	}

	if (getParameterByName("pen15", null) == "ouija") {
		pen15Ouija(session);
	}



	if (getParameterByName("faces", null) == "off") {
		faceOffMode(session);
	}

	if (getParameterByName("tier", null) == "cod" || getParameterByName("mode", null) == "manic") {
		bardQuestMode(session);
	}

	if (getParameterByName("lollipop", null) == "true") {
		tricksterMode(session);
	}

	if (getParameterByName("robot", null) == "true") {
		roboMode(session);
	}

	if (getParameterByName("sbajifier", null) == "true") {
		sbahjMode(session);
	}

	if (getParameterByName("babyStuck", null) == "true") {
		babyStuckMode(session);
	}

	if(session.session_id == 413){
		session413(session);
	}else if(session.session_id == 612){
		session612(session);
	}else if(session.session_id == 613){
		session613(session);
	}else if(session.session_id == 1025){
		session1025(session);
	}else if(session.session_id == 33){
		session33(session);
	}else if(session.session_id == 111111){
		session111111(session);
	}else if(session.session_id == 88888888){
		session88888888(session);
	}else if(session.session_id == 420){
		session420(session);
	}else if(session.session_id == 0){
		session0(session);
	}else if(session.session_id == 13){ //wait, why is THIRTEEN an arc number ???
		session13(session);
	}

	//if it's not a known one, no problem.
	NonCanonSessions.callSession(session,session.session_id);

	if(getParameterByName("self",null)  == "cest") {
		anstusMode(session);
	}

	if(getParameterByName("images",null)  == "pumpkin"){
		doNotRender = true;
	}

	if(getParameterByName("prophecy",null)  == "pigeon"){
		pigeonStuck(session);
	}

	if(getParameterByName("easter",null)  == "egg"){
		easter_egg = true;
		window.alert("Yo Dawg, I herd you liek easter eggs???");
	}


	if(getParameterByName("selfInsertOC",null)  == "true"){
		//;
		// call a method, method will determine what other params exist, like reddit=true and shit.;
		window.alert("Uh. Long story short, JR took this functionality out to make AB saner. Maybe it will work again soon. Maybe.");
		//await processFanOCs();
	}

	//not an else if because this OVERIDES other easter egg sessions. but called here and not where other params are 'cause needs to have session initialized first.
	if(getParameterByName("nepeta",null)  == ":33"){
		nepetaQuest(session); //ANY session can be all nepetas.
	}

	if(getParameterByName("luck",null)  == "AAAAAAAALL"){
		lucky8rk(session);
	}

	if(getParameterByName("honk",null)  == ":o)"){
		fridgeQuest(session);
	}

	if(getParameterByName("shenanigans",null)  == "temporal"){
		aradiaQuest(session);
	}

	if(getParameterByName("home",null)  == "stuck"){
		homestuck(session);
	}

	if(getParameterByName("hive",null)  == "bent"){
		hivebent(session);
	}

	if(getParameterByName("open",null)  == "bound"){
		openBound(session);
	}

	if(getParameterByName("rumpus",null)  == "fruity"){
		fruityRumpusAssholeFactory(session);
	}

	if(getParameterByName("lawnring",null)  == "yellow"){
		janusReward(session);
	}

	if(getParameterByName("lawnring",null)  == "prospit"){
		dreamGnosis(session);
	}

	processXStuck(session); //might not do anything.
}



void janusReward(Session session){
	session.janusReward = true;
}



//omg, so easy, KnightStuck = true, SylphStuck = true, PageStuck = true.;
//if last word is stuck, look for first word in either all class, or all aspects, mod the approriate thing to be the first word.
//auto works with new claspects, too. genius
void processXStuck(Session session){
	if(window.location.search.isEmpty && simulatedParamsGlobalVar.isEmpty) {
	  //;
		return;
	}
	String params1 = null;
	if(window.location.search.isNotEmpty) params1 = window.location.search.substring(1);
	String params2 = simulatedParamsGlobalVar;
	//;
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
				setAllClassesTo(session,stuck[0].trim());
			}else if(all_aspects.indexOf(stuck[0]) != -1){
				setAllAspectsTo(session,stuck[0].trim());
			}
		}
	}

}



void setAllAspectsTo(Session session,String a){
	//;
	Aspect aspect = Aspects.stringToAspect(a);
	for(num i = 0; i<session.players.length; i++){
		if(session.players[i].aspect != Aspects.TIME && session.players[i].aspect != Aspects.SPACE ) session.players[i].aspect = aspect; //You can have no space/time in your own sessions, but AB will never do it on purpose.
		if(session.players[i].guardian.aspect != Aspects.TIME && session.players[i].guardian.aspect != Aspects.SPACE ) session.players[i].guardian.aspect = aspect;
	}
}



void setAllClassesTo(Session session,String c){
	//;
	SBURBClass class_name = SBURBClassManager.stringToSBURBClass(c);
	for(num i = 0; i<session.players.length; i++){
		session.players[i].class_name = class_name;
		session.players[i].guardian.class_name = class_name;
	}
}


//TBH i'm tempted to disable this feature entirely if it ends up being the one thing
//bteween AB and sanity
Future<Null> processFanOCs(Session session) async {
	//start up an easterEggEngine.
	await new CharacterEasterEggEngine().loadArraysFromFile(session,true); //<-- ASYNCHRONOUS, so MUST END HERE. any future steps should be in the easterEggEngine itself.
}






void babyStuckMode(Session session){
	if(!doNotRender) window.alert("goo goo GA GAH!");
	for(num j = 0; j<session.players.length; j++){
		Player p = session.players[j];
		p.baby_stuck = true;
		p.quirk.lettersToReplaceIgnoreCase.addAll([["e", "goo"],["a","gah"],["i","ga"],["o","blooo"],["u","guuuu"]]);
	}
}



//AB told me this was funny! I SWEAR I am not Robo-Racist! It's IRONIC.
void roboMode(Session session){
	if(!doNotRender) window.alert("BEEP");
	appendHtml(SimController.instance.storyElement,"<img src = 'images/guide_bot.png' style='float:left;'>");
	for(num j = 0; j<session.players.length; j++){
		var p = session.players[j];
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



void tricksterMode(Session session){
	if(!doNotRender) window.alert("I FEEL JUST PEEEEEEEEEEEACHY!!!!!!!!!!!");
	if(!doNotRender &&  querySelector("#avatar") != null) (querySelector("#avatar") as ImageElement).src = "images/CandyAuthorBot.png";
	appendHtml(SimController.instance.storyElement,"<img src = 'images/trickster_author.png' style='float:left;'><img src = 'images/trickster_artist.png' style='float:left;'>");
	querySelector('body').style.backgroundImage =  "url(images/zilly.gif)"; //.style.backgroundColor
	querySelector('#story').style.backgroundColor ="#ff93e4";
	for(num j = 0; j<session.players.length; j++){
		var p = session.players[j];
		if(p.aspect != Aspects.DOOM){ //kr says it would be funny if doom plalyers completely immune.
			p.hairColor = session.rand.pickFrom(tricksterColors).toStyleString();
			p.bloodColor = session.rand.pickFrom(tricksterColors).toStyleString();
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



void debugRoyalRumble(Session session){
	if(!doNotRender) window.alert("royal rumble!");
	for(num j = 0; j<session.players.length; j++){
		var p = session.players[j];
		p.isTroll = true; //only .evel 2 players up
		p.bloodColor = "#99004d";
		p.addStat(Stats.SANITY,-10);
		p.decideLusus();
		p.hairColor = "#000000";
		p.object_to_prototype = p.myLusus;
		p.relationships = [];
		p.quirk = null;
		p.generateRelationships(session.players);  //heiresses hate each other
		p.quirk = randomTrollSim(session.rand, p);
	}
}


void session413(Session session){
	//;
	for(int i = 0; i<8; i++){
		Player player;
		Player guardian;
		if(i< session.players.length){
			player = session.players[i];
			//;
		}else{
			//;
			player = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			guardian.quirk = randomHumanSim(session.rand, guardian);
			player.quirk = randomHumanSim(session.rand, player);
			player.guardian = guardian;
			guardian.guardian = player;
			session.players.add(player);
		}
	}

	for(int i = 0; i<8; i++){
		Player player = session.players[i];
		Player guardian = player.guardian;
		player.relationships = [];
		List<Player> guardians = getGuardiansForPlayers(session.players);
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(session.players);
		session413IndexToHuman(session,player, i);
		session413IndexToAncestor(session,guardian, i);//just call regular with a different index
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
	session.players.length = 8; //no more, no less.
}








void session111111(Session session){
	for(int i = 0; i<8; i++){
		Player  player;
		Player guardian;
		if(i< session.players.length){
			player = session.players[i];
		}else{
			player = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			guardian.quirk = randomHumanSim(session.rand,guardian);
			player.quirk = randomHumanSim(session.rand,player);
			player.guardian = guardian;
			guardian.guardian = player;
			session.players.add(player);
		}
	}

	for(int i = 0; i<8; i++){
		Player player = session.players[i];
		Player guardian = player.guardian;
		player.relationships = [];
		List<Player> guardians = getGuardiansForPlayers(session.players);
		guardian.generateBlandRelationships(guardians);
		player.generateBlandRelationships(session.players);
		session413IndexToAncestor(session,player, i);
		session413IndexToHuman(session,guardian, i);//just call regular with a different index
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
	session.players.length = 8; //no more, no less.
}



void session413IndexToHuman(Session session,Player player, int index){
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
		player.land = player.spawnLand();
		player.land.name = "Land of Wind and Shade";
		player.moon = session.prospit;
	}else if(index == 1){
		player.moon = session.derse;
		player.bloodColor = "#ff0000";
		player.godDestiny = true;
		player.class_name = SBURBClassManager.SEER;
		player.land = player.spawnLand();
		player.land.name = "Land of Light and Rain";
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
		player.moon = session.derse;
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.KNIGHT;
		player.land = player.spawnLand();
		player.land.name = "Land of Heat and Clockwork";
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
		player.moon = session.prospit;
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.WITCH;
		player.land = player.spawnLand();
		player.land.name = "Land of Frost and Frogs";
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
		player.moon = session.prospit;
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.MAID;
		player.godDestiny = true;
		player.aspect = Aspects.LIFE;
		player.land = player.spawnLand();
		player.land.name = "Land of Crypts and Helium";

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
		player.moon = session.derse;
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.ROGUE;
		player.land = player.spawnLand();
		player.land.name = "Land of Pyramids and Neon";
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
		player.moon = session.derse;
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.PRINCE;
		player.land = player.spawnLand();
		player.land.name = "Land of Tombs and Krypton";
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
		player.moon = session.prospit;
		player.bloodColor = "#ff0000";
		player.class_name = SBURBClassManager.PAGE;
		player.land = player.spawnLand();
		player.land.name = "Land of Mounds and Xenon";
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
void session413IndexToAncestor(Session session,Player player, int index){
	player.isTroll = false;
	if(index == 0){
		session413IndexToHuman(session,player, 4);
	}else if(index == 1){
		session413IndexToHuman(session,player, 5);
	}else if(index == 2){
		session413IndexToHuman(session,player, 6);
	}else if(index == 3){
		session413IndexToHuman(session,player, 7);
	}else if(index == 4){
		session413IndexToHuman(session,player, 0);
	}else if(index == 5){
		session413IndexToHuman(session,player, 1);
	}else if(index == 6){
		session413IndexToHuman(session,player, 2);
	}else if(index == 7){
		session413IndexToHuman(session,player, 3);
	}
}





//time player is dave space player is either jade
//all else is 413 human.
void homestuck(Session session){
	//var savedSeed = session.session_id;
	Random rand = new Random(session.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random
	//copyPlayerFromTemplate(p,template);
	for(num i = 0; i<session.players.length; i++){
		var p = session.players[i];
		var g = p.guardian;
		if(p.aspect == Aspects.TIME){
			session413IndexToHuman(session,p,2);
			session413IndexToAncestor(session,g,2);
		}else if(p.aspect == Aspects.SPACE){
			session413IndexToHuman(session,p,3);
			session413IndexToHuman(session,g,3);
		}else{
			var index = rand.nextIntRange(0,7);
			session413IndexToHuman(session,p,index);
			session413IndexToAncestor(session,g,index);
		}
	}
}



//time player is aradia, space player is kanaya,
//all else random alternian troll
void hivebent(Session session){
  Random rand = new Random(session.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random

  for(num i = 0; i<session.players.length; i++){
		var p = session.players[i];
		var g = p.guardian;
		if(p.aspect == Aspects.TIME){
			session612IndexToTroll(session,p,4);
			session612IndexToTrollAncestor(session,g,4);
		}else if(p.aspect == Aspects.SPACE){
			session612IndexToTroll(session,p,8);
			session612IndexToTrollAncestor(session,g,8);
		}else{
			var index = rand.nextIntRange(0,11);
			session612IndexToTroll(session,p,index);
			session612IndexToTrollAncestor(session,g,index);
		}
	}
}

void pigeonStuck(Session session) {
	window.alert("...Well. Fuck.");
	for(Player p in session.players) {
		p.deriveSpecibus = false;
		p.specibus = new Specibus("Pigeon", ItemTraitFactory.PIGEON, [ ItemTraitFactory.FEATHER, ItemTraitFactory.CORRUPT],shogunDesc: "PsychologyAndExtremeViolenceKind", abjDesc:"Shit. Better get JR. They'll want to see this.");

	}
}

void dreamGnosis(Session session) {
	window.alert("...Well. Hope you enjoy a Wasted session full of obsessive assholes.");
	appendHtml(SimController.instance.storyElement, session.mutator.dream(session,session.players.first));

}

//all players are the leader player
void anstusMode(Session session) {
	Player template = session.players[0];
	for(Player p in session.players) {
		bool space = p.aspect == Aspects.SPACE;
		bool time = p.aspect == Aspects.TIME;
		p.copyFromPlayer(template);
		if(space) p.aspect = Aspects.SPACE;
		if(time) p.aspect = Aspects.TIME;
	}
}


//time player is damara, space player is porrim
//all else random beforan troll
void openBound(Session session){
  Random rand = new Random(session.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random

  for(num i = 0; i<session.players.length; i++){
		var p = session.players[i];
		var g = p.guardian;
		if(p.aspect == Aspects.TIME){
			session612IndexToTroll(session,g,4);
			session612IndexToTrollAncestor(session,p,4);
		}else if(p.aspect == Aspects.SPACE){
			session612IndexToTroll(session,g,8);
			session612IndexToTrollAncestor(session,p,8);
		}else{
			var index = rand.nextIntRange(0,11);
			session612IndexToTroll(session,g,index);
			session612IndexToTrollAncestor(session,p,index);
		}
	}
}



//time player is aradia, damara or dave, space is jade, porrim or kanaya
//all else is randomly alternian or beforan or human.
//rumpus = fruity;
//i will have order in this rumpusBlock! Or the opposite !!!
void fruityRumpusAssholeFactory(Session session){
  Random rand = new Random(session.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random
  for(num i = 0; i<session.players.length; i++){
		var p = session.players[i];
		var g = p.guardian;
		var randNum = rand.nextDouble();
		if(p.aspect == Aspects.TIME){
			if(randNum > 0.6){
				session612IndexToTroll(session,g,4);
				session612IndexToTrollAncestor(session,p,4);
			}else if(randNum > 0.3){
				session612IndexToTrollAncestor(session,p,4);
				session612IndexToTroll(session,g,4);
			}else{
				session413IndexToHuman(session,p,2);
				session413IndexToHuman(session,g,2);
			}
		}else if(p.aspect == Aspects.SPACE){
			if(randNum > 0.6){
				session612IndexToTroll(session,g,8);
				session612IndexToTrollAncestor(session,p,8);
			}else if(randNum > 0.3){
				session612IndexToTrollAncestor(session,p,8);
				session612IndexToTroll(session,g,8);
			}else{
				session413IndexToHuman(session,p,3);
				session413IndexToHuman(session,g,3);
			}
		}else{
			if(randNum > 0.6){
				var index = rand.nextIntRange(0,12);
				session612IndexToTroll(session,g, index);
				session612IndexToTrollAncestor(session,p,index);
			}else if(randNum > 0.3){
				var index = rand.nextIntRange(0,12);
				session612IndexToTrollAncestor(session,p,index);
				session612IndexToTroll(session,g,index);
			}else{
				var index = rand.nextIntRange(0,7);
				session413IndexToHuman(session,p,index);
				session413IndexToAncestor(session,g,index);
			}
		}
	}
}




//like nepeta quest, but with gamzee instead of nepeta.
void aradiaQuest(Session session){

	for(num i = 0; i< session.players.length; i++){
		var player = blankPlayerNoDerived(session); //unlike gamzee or vriska, aradias can be different
		session612IndexToTroll(session,player, 4);
		var p = session.players[i];
		var g = p.guardian;
		p.id = i;
		g.id = i + 111111;
		copyPlayerFromTemplate(session,p,player);
		copyPlayerFromTemplate(session,g,player);
	}
}



//like nepeta quest, but with gamzee instead of nepeta.
void fridgeQuest(Session session){
	var player = blankPlayerNoDerived(session);
	session612IndexToTroll(session,player, 2);
	copyPlayersFromTemplate(session,player);
}




//everyone replaced by vriska. thief of space and thief of time.
void lucky8rk(Session session){
	var player = blankPlayerNoDerived(session);
	session612IndexToTroll(session,player, 7);
	copyPlayersFromTemplate(session,player);
}



void copyPlayerFromTemplate(Session session, Player p, Player template){
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
void copyPlayersFromTemplate(Session session,template){
	for(num i = 0; i< session.players.length; i++){
		var p = session.players[i];
		var g = p.guardian;
		p.id = i;
		g.id = i + 111111;
		copyPlayerFromTemplate(session,p,template);
		copyPlayerFromTemplate(session,g,template);
	}
}




//call this ONLY after initializing normal players.
void nepetaQuest(Session session){
	querySelector('body').style.backgroundImage = "url(images/cat_background_tile_nep.png)";
	//will it be 12 nepetas roleplaying as their original players?
	//or 12 canon trolls all roleplaying as nepeta?
	//it's shrodinger's nepeta!!!
	var actualRandomNumber = new Random().nextInt(); //no fucking seed.

	for(num i = 0; i< session.players.length ;i++){
		Player player = session.players[i];
    Player guardian = player.guardian;
		player.isTroll = true;
		guardian.isTroll = true;
		sawNepeta();
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



void session88888888(Session session){
	session.players = []; //rip players, too bad about the 8ad 8rk
	for(int i = 0; i<8; i++){
		var player;
		var guardian;
		player = blankPlayerNoDerived(session);
		guardian = blankPlayerNoDerived(session);
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
		session.players.add(player);
	}
	lucky8rk(session);
	for(num i = 0; i<session.players.length;i++){
		var player = session.players[i];
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
		var guardians = getGuardiansForPlayers(session.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(session.players);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}



void session420(Session session){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i>session.players.length){
			//;
			player = blankPlayerNoDerived(session);
			guardian = blankPlayerNoDerived(session);
			player.initialize();
			guardian.initialize();
			player.guardian = guardian;
			guardian.guardian = player;
			session.players.add(player);
		}
	}

	fridgeQuest(session);
	for(num i = 0; i<session.players.length;i++){
		var player = session.players[i];
		var guardian = player.guardian;
		player.relationships = [];
		guardian.relationships = [];
		var guardians = getGuardiansForPlayers(session.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(session.players);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}


}

//what even is this???
void session13(Session session) {
    session.mutator.metaHandler.initalizePlayers(session,true);
	session.players = new List<Player>.from(session.mutator.metaHandler.metaPlayers); //just blow them away.
    //will this be enough to get shogun in?
    if(session.aliensClonedOnArrival.isNotEmpty) {
    	//window.alert("adding shogun");
    	//causes an infinite loop
	    List<Player> aliens = new List<Player>.from(session.aliensClonedOnArrival);
	    session.aliensClonedOnArrival.clear();
	    session.addAliensToSession(aliens);
	    //session.players.addAll(session.aliensClonedOnArrival);
    }
    ;
    session.players[0].leader = true;
    for(Player p in session.players) {
        p.ectoBiologicalSource = null; //can do ectobiology.
    }

    for(num i = 0; i<session.players.length;i++){
        Player player = session.players[i];
        Player  guardian = player.guardian;
        player.relationships = [];
        guardian.relationships = [];
        List<Player> guardians = getGuardiansForPlayers(session.players);
        guardian.generateRelationships(guardians);
        player.generateRelationships(session.players);
        player.mylevels = getLevelArray(player);
        guardian.mylevels = getLevelArray(guardian);
    }
}

void sawNepeta() {
	;
	if(!window.localStorage.containsKey("catTroll")) {
		window.localStorage["catTroll"] = "1";
	}else {
		window.localStorage["catTroll"] = "${int.parse(window.localStorage["catTroll"]) +1}";
	}

}

void session0(Session session){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i>session.players.length){
			//;
			player = blankPlayerNoDerived(session);
			guardian = blankPlayerNoDerived(session);
			player.guardian = guardian;
			guardian.guardian = player;
			player.initialize();
            guardian.initialize();
			session.players.add(player);
		}
	}

	aradiaQuest(session);
	for(num i = 0; i<session.players.length;i++){
		Player player = session.players[i];
		Player  guardian = player.guardian;
		player.relationships = [];
		guardian.relationships = [];
		List<Player> guardians = getGuardiansForPlayers(session.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(session.players);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}


}



//12 dead nepetas
void session33(Session session){
	//will it be 12 nepetas roleplaying as their friends?
	//or 12 canon trolls all roleplaying as nepeta?
	//it's shrodinger's nepeta!!!
	session612(session);

	nepetaQuest(session);

}



//can't control HOW the session will turn out, but can at least give it the right players.
void session613(Session session){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i<session.players.length){
			player = session.players[i];
		}else{
			player = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			player.initialize();
            guardian.initialize();
			guardian.quirk = randomTrollSim(session.rand, guardian);
			player.quirk = randomTrollSim(session.rand,player);
			//session.guardians.add(guardian);
			session.players.add(player);
			player.guardian = guardian;
			guardian.guardian = player;
		}
	}

	for(int i = 0; i<12; i++){
		Player player = session.players[i];
		Player guardian = player.guardian;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(session.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(session.players);
		session612IndexToTrollAncestor(session,player, i);
		session612IndexToTroll(session,guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}



//can't control HOW the session will turn out, but can at least give it the right players.
void session612(Session session){
	for(int i = 0; i<12; i++){
		var player;
		var guardian;
		if(i<session.players.length){
			player = session.players[i];
		}else{
			player = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			player.initialize();
            guardian.initialize();
			guardian.quirk = randomTrollSim(session.rand,guardian);
			player.quirk = randomTrollSim(session.rand,player);
			//session.guardians.add(guardian);
			session.players.add(player);
			player.guardian = guardian;
			guardian.guardian = player;
		}
	}

	for(int i = 0; i<12; i++){
		Player player = session.players[i];
		Player guardian = player.guardian;
		player.relationships = [];
		var guardians = getGuardiansForPlayers(session.players);
		guardian.generateRelationships(guardians);
		player.generateRelationships(session.players);
		session612IndexToTroll(session,player, i);
		session612IndexToTrollAncestor(session,guardian, i);
		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}
}


//["#A10000","#a25203","#a1a100","#658200","#416600","#078446","#008282","#004182","#0021cb","#631db4","#610061","#99004d"]
//karkat, terezi, gamzee, equius, aradia, nepeta, tavros, vriska, kanaya, eridan, feferi, sollux
void session612IndexToTroll(Session session, Player player, int index){
	player.hairColor = "#000000";
	player.isTroll = true;
	player.deriveChatHandle = false;
	player.deriveLand = false;
	if(index == 0){
		player.aspect = Aspects.BLOOD;
		player.moon = session.prospit;
		player.bloodColor = "#ff0000";
		player.land = player.spawnLand();
		player.land.name = "Land of Pulse and Haze";
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
		player.moon = session.prospit;
		player.aspect = Aspects.MIND;
		player.land = player.spawnLand();
		player.land.name = "Land of Thought and Flow";
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
		player.moon = session.prospit;
		player.aspect = Aspects.RAGE;
		player.land = player.spawnLand();
		player.land.name = "Land of Mirth and Tents";
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
		player.moon = session.derse;
		player.land = player.spawnLand();
		player.land.name = "Land of Caves and Silence";
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
		player.moon = session.derse;
		player.aspect = Aspects.TIME;
		player.class_name = SBURBClassManager.MAID;
		player.land = player.spawnLand();
		player.land.name = "Land of Quartz and Melody";
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
    Random rand = new Random(session.session_id); //don't use session's rand cuz want to not eat seeds here but also don't allow true random

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
		var f = new Fraymotif( "Telekinesis", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif( "Ghost Communing", 1);
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,true));
		f.effects.add(new FraymotifEffect(Stats.SANITY,3,false));
		f.desc = " The souls of the dead start hassling all enemies. ";
		player.fraymotifs.add(f);

	}else if(index == 5){
		player.moon = session.derse;
		player.aspect = Aspects.HEART;
		player.land = player.spawnLand();
		player.land.name = "Land of Little Cubes and Tea";
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
		sawNepeta();
		player.quirk.suffix = "";
		player.quirk.prefix = ":33 < t";
	}else if(index == 6){
		player.moon = session.prospit;
		player.aspect = Aspects.BREATH;
		player.land = player.spawnLand();
		player.land.name = "Land of Sand and Zephyr";
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
		player.moon = session.prospit;
		player.land = player.spawnLand();
		player.land.name = "Land of Maps and Treasure";
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
		player.moon = session.prospit;
		player.land = player.spawnLand();
		player.land.name = "Land of Rays and Frogs";
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
		player.moon = session.derse;
		player.land = player.spawnLand();
		player.land.name = "Land of Wrath and Angels";
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
		player.moon = session.derse;
		player.land = player.spawnLand();
		player.land.name = "Land of Dew and Glass";
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
		player.moon = session.derse;//no way to have two dream selves righ tnow.;
		player.land = player.spawnLand();
		player.land.name = "Land of Brains and Fire";
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
		Fraymotif f = new Fraymotif( "Telekinesis", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif( "Optic Blast", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Red and blue eye beams pierce the ENEMY. ";
		player.fraymotifs.add(f);
	}
}



void session612IndexToTrollAncestor(Session session, Player player, index){
	player.hairColor = "#000000";
	player.isTroll = true;
	player.deriveChatHandle = false;
    player.deriveLand = false;
	if(index == 0){
		player.moon = session.prospit;
		player.aspect = Aspects.BLOOD;
		player.bloodColor = "#ff0000";
		player.land = player.spawnLand();
		player.land.name = "Land of Pulse and Haze";
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
		player.moon = session.prospit;
		player.land = player.spawnLand();
		player.land.name = "Land of Thought and Flow";
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
		player.moon = session.prospit;
		player.land = player.spawnLand();
		player.land.name = "Land of Mirth and Tents";
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
		player.moon = session.derse;
		player.aspect = Aspects.VOID;
		player.land = player.spawnLand();
		player.land.name = "Land of Caves and Silence";
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
		player.moon = session.derse;
		player.aspect = Aspects.TIME;
		player.class_name = SBURBClassManager.WITCH;
		player.land = player.spawnLand();
		player.land.name = "Land of Quartz and Melody";
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
		var f = new Fraymotif( "Telekinesis", 1);
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
		player.moon = session.derse;
		player.class_name = SBURBClassManager.MAGE;
		player.land = player.spawnLand();
		player.land.name = "Land of Little Cubes and Tea";
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
		player.moon = session.prospit;
		player.land = player.spawnLand();
		player.land.name = "Land of Sand and Zephyr";
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
		player.moon = session.prospit;
		player.land = player.spawnLand();
		player.land.name = "Land of Maps and Treasure";
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
		player.moon = session.prospit;
		player.land = player.spawnLand();
		player.land.name = "Land of Rays and Frogs";
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
		player.moon = session.derse;
		player.land = player.spawnLand();
		player.land.name = "Land of Wrath and Angels";
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
		player.moon = session.derse;
		player.aspect = Aspects.LIFE;
		player.land = player.spawnLand();
		player.land.name = "Land of Dew and Glass";
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
		player.moon = session.derse;
		player.land = player.spawnLand();
		player.land.name = "Land of Brains and Fire";
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
		var f = new Fraymotif( "Telekinesis", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Large objects begin pelting the ENEMY. ";
		player.fraymotifs.add(f);

		f = new Fraymotif( "Optic Blast", 1);
		f.effects.add(new FraymotifEffect(Stats.POWER,2,true));
		f.desc = " Red and blue eye beams pierce the ENEMY. ";
		player.fraymotifs.add(f);
	}
}



void session1025(Session session){
	for(int i = 0; i<12; i++){
		Player  player;
		Player  guardian;
		if(i<session.players.length){
			player = session.players[i];
		}else{
			player = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			guardian = randomPlayerNoDerived(session,SBURBClassManager.PAGE, Aspects.VOID);
			guardian.quirk = randomTrollSim(session.rand, guardian);
			player.quirk = randomTrollSim(session.rand,player);
			//session.guardians.add(guardian);
			player.guardian = guardian;
			guardian.guardian = player;
			session.players.add(player);
		}
	}

	for(int i = 0; i<12; i++){
		Player player = session.players[i];
		Player  guardian = player.guardian;
		if(i<8){
			session413IndexToHuman(session,player,i);
			session413IndexToAncestor(session,guardian,i);
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
			session612IndexToTroll(session,player, index);
			session612IndexToTroll(session,guardian, index);
		}
		var guardians = getGuardiansForPlayers(session.players);
		guardian.generateRelationships(guardians);
		player.relationships = [];
		player.generateRelationships(session.players);

		player.mylevels = getLevelArray(player);
		guardian.mylevels = getLevelArray(guardian);
	}

}
