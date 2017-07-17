

//looking for rare sessions  not rendering.
//I just realized that AuthorBot was technically born in a lab!!!
//Okay, like, not in a MEANINGFUL way, but they were replacing the carpet in the regular area so i had to work out of the lab instead.
//and before you worry, YES I work on this at my day job. But, like, I'm explicitly allowed to do "mad science" learning projects
//during downtime (as long as i don't make money off it), it helps keep my skillz (yes with a 'z') sharp.  90% of the tech i work with
//proffesionally was first learned this way. go me.
//this whole bucket of spiders was intended to be a way for me to solidify my understanding of javascript arrays and debugging.
//and let me tell you for free: I am the goddamn master of javascript debugging at this point. at least compared to past me.
//have you seen some of the other things I've done? Nothing as complicated as this (or as Homestuck as this.)
//http://purplefrog.com/~jenny/
//that's a list of all the javascript projects i've done over the years. i've done plenty of non javascript shit, too, but, well, not as easily shareable.
//I think: http://purplefrog.com/~jenny/PheremoneMaze/Worlds/story_pheremone.html
//is particularly related to SBURB SIM.  AI simulation tied into a story engine.
//but the "I" in AI was stronger over there. It was a dead simple genetic algorithm of creatures living in a world filled with plants and predators.
//their 'DNA' was literally just the directions they would move over their life. but they would evolve, and it was neat to watch.
//the 'voice' of the narratator is shamelessly inspired by the game Bastion, so that tells you how old that sim is. 20-goddamned-11.  That's 6 years old now. damn.

//bob warned me about global variables. he told me, dog.
bool simulationMode = true;
bool pwMode = false;
bool debugMode = false;
num spriteWidth = 400;
num spriteHeight = 300;
num canvasWidth = 1000;
num canvasHeight = 300;
num repeatTime = 5;
bool version2 = true; //even though idon't want  to render content, 2.0 is different from 1.0 (think of dialog that triggers)
bool junior = false;

List<dynamic> sessionObjects = [];
var curSessionGlobalVar;
List<dynamic> sessionsSimulated = [];
List<dynamic> allSessionsSummaries = [];
List<dynamic> sessionSummariesDisplayed = [];

num numSimulationsDone = 0;
num numSimulationsToDo = 52;
bool quipMode = false;
bool needToScratch = false;
bool displayRomance = true;
bool displayEnding = true;
bool displayDrama = true;
bool displayCorpse = false;
bool displayMisc = true;
bool displayAverages = true;
bool displayClasses = false;
bool displayAspects = false;
bool tournamentMode = false;



//want the AuthorBot to actually be browsing sessions when bored, like she claims to be.
void robotMode(){
	numSimulationsToDo = 1;
	startSession();
}




void checkPassword(){
	//print("click");
	numSimulationsDone = 0; //but don't reset stats
	sessionSummariesDisplayed = [];

	numSimulationsToDo =1;
	var tmp = parseInt(querySelector("#pwtext").val());
	if(isNaN(tmp)){
		alert("Not even close!!!");
	}else if(tmp == 33 || getParameterByName("nepeta")  == ":33"){
		alert("I'm afraid I can't do that, Observer. I refuse to look at sessions with true randomness, and those cat trolls are random as FUCK.");
	}else{
		alert("Hrrrm...let me think about it.");
		Math.seed = tmp;
		initial_seed = parseInt(querySelector("#pwtext").val());
		pwMode = true;
		startSession();
	}

}



void showHint(){
	querySelector("#spoiler").toggle();
}



//kid boy and abj is canon
//you'll know that ABJ is thinking of kid boi every time she says "Interesting!!!"
//it will be secret code
//and definitely not terrifying at all
void filterSessionsJunior(){
	var num_players = parseInt(querySelector("#num_players").val());
	List<dynamic> tmp = [];
	sessionSummariesDisplayed = [];
	for(num i = 0; i<allSessionsSummaries.length; i++){
		sessionSummariesDisplayed.push(allSessionsSummaries[i]);
	}

	for(num i = 0; i<sessionSummariesDisplayed.length; i++){
		var ss = sessionSummariesDisplayed[i];
		if(ss.players.length == num_players){
			tmp.push(ss);
		}
	}
	sessionSummariesDisplayed = tmp;
	printSummariesJunior();
	printStatsJunior();
}



dynamic removeNonMatchingClasspects(tmp, classes, aspects){
	List<dynamic> toRemove = [];
	for(num i = 0; i<tmp.length; i++){
		var ss = tmp[i];
		if(!ss.matchesClasspect(classes, aspects)){
			toRemove.push(ss);
		}
	}

	for(num i = 0; i<toRemove.length; i++){
		tmp.removeFromArray(toRemove[i]);
	}

	return tmp;
}



//filters by all checkboxes.
void filterSessionSummaries(){
	List<dynamic> tmp = [];
	List<dynamic> filters = [];
	sessionSummariesDisplayed = [] ;//can filter already filtered arrays.;
	for(num i = 0; i<allSessionsSummaries.length; i++){
			sessionSummariesDisplayed.push(allSessionsSummaries[i]);
	}

	querySelector("input[name='filter']:checked").each((){;
		filters.push(querySelector(this).val());
	});
		for(num i = 0; i<sessionSummariesDisplayed.length; i++){
			var ss = sessionSummariesDisplayed[i];
			if(ss.satifies_filter_array(filters)){
				tmp.push(ss);
			}
	}

	List<dynamic> classes = [];
	List<dynamic> aspects = [];

	querySelector("input[name='filterAspect']:checked").each((){;
		aspects.push(querySelector(this).val());
	});

	querySelector("input[name='filterClass']:checked").each((){;
		classes.push(querySelector(this).val());
	});

	tmp = removeNonMatchingClasspects(tmp,classes,aspects);


	////print(tmp);
	sessionSummariesDisplayed = tmp;
	printSummaries();
	printStats(filters,classes, aspects);
}


//filter is proprety name, some are special, most just pass through
void filterSessionSummariesBy(filter){
	//print("Filtering session summaries by: " + filter);
	sessionSummariesDisplayed = [];
	if(!filter){
		for(num i = 0; i<allSessionsSummaries.length; i++){
			sessionSummariesDisplayed.push(allSessionsSummaries[i]);
		}
		printSummaries();
		printStats();
		return;
	}
	var tmp = [] ;//can filter already filtered arrays.;
	for(num i = 0; i<sessionSummariesDisplayed.length; i++){
		var ss = sessionSummariesDisplayed[i];
		if(!filter){
			tmp.push(ss);  //add all, but deep copy
		}else if(filter == "No Frog" && ss.frogStatus == filter){
			tmp.push(ss);
		}else if(filter == "Sick Frog" && ss.frogStatus == filter){
			tmp.push(ss);
		}else if(filter == "Full Frog" && ss.frogStatus == filter){
			tmp.push(ss);
		}else if(filter == "timesAllDied" && ss.numLiving == 0){
			tmp.push(ss);
		}else if(filter == "timesAllLived" && ss.numDead == 0){
			tmp.push(ss);
		}else if(ss[filter]){
			//print("adding filter");
			tmp.push(ss);
		}
	}
	sessionSummariesDisplayed = tmp;
	printSummaries();
	printStats();
}



void checkSessionsJunior(){
	junior = true;
	numSimulationsDone = 0; //but don't reset stats
	sessionSummariesDisplayed = [];
	for(num i = 0; i<allSessionsSummaries.length; i++){
		sessionSummariesDisplayed.push(allSessionsSummaries[i]);
	}
	querySelector("#story").html("");
	numSimulationsToDo = parseInt(querySelector("#num_sessions").val());
	querySelector("#button").prop('disabled', true);
	startSessionJunior();
}



//tournament will pass a callback here. after each session, callback should be called.
void checkSessions(){
	numSimulationsDone = 0; //but don't reset stats
	sessionSummariesDisplayed = [];
	for(num i = 0; i<allSessionsSummaries.length; i++){
			sessionSummariesDisplayed.push(allSessionsSummaries[i]);
	}
	//don't filter by anything.
	querySelector("input[name='filter']").each((){;
			querySelector(this).prop('checked', false);
	});
	querySelector("#story").html("");
	//querySelector("#debug").html("");
	//querySelector("#stats").html("");
	numSimulationsToDo = parseInt(querySelector("#num_sessions").val());
	querySelector("#button").prop('disabled', true);
	startSession();
}



void formInit(){
	querySelector("#button").prop('disabled', false);
	querySelector("#num_sessions_text").val(querySelector("#num_sessions").val());
	querySelector("#num_sessions").change((){
			querySelector("#num_sessions_text").val(querySelector("#num_sessions").val());
	});
}




void startSessionJunior(){
	querySelector("#story").html("");
	curSessionGlobalVar = new Session(initial_seed);
	reinit();
	createScenesForSession(curSessionGlobalVar);
	//initPlayersRandomness();
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	curSessionGlobalVar.makeGuardians(); //after entry order established
	if(getParameterByName("royalRumble")  == "true"){
		debugRoyalRumble();
	}

	if(getParameterByName("lollipop")  == "true"){
		tricksterMode();
	}

	if(getParameterByName("robot")  == "true"){
		roboMode();
	}

	if(getParameterByName("sbajifier")  == "true"){
		sbahjMode();
	}

	if(getParameterByName("babyStuck")  == "true"){
		babyStuckMode();
	}
	checkEasterEgg(easterEggCallBackJR);

}



void easterEggCallBackJR(){
	initializePlayers(curSessionGlobalVar.players, curSessionGlobalVar);  //need to redo it here because all other versions are in case customizations
	//aaaaand. done.
	sessionsSimulated.push(curSessionGlobalVar.session_id);
	var sum = curSessionGlobalVar.generateSummary();
	var sumJR = sum.getSessionSummaryJunior();
	allSessionsSummaries.push(sumJR);
	sessionSummariesDisplayed.push(sumJR);
	var str = sumJR.generateHTML();
	debug("<br><hr><font color = 'orange'> ABJ: " + getQuipAboutSessionJunior() + "</font><Br>" );
	debug(str);
	printStatsJunior();
	numSimulationsDone ++;
	if(numSimulationsDone >= numSimulationsToDo){
			querySelector("#button").prop('disabled', false);
	}else{
		Math.seed =  getRandomSeed();
		initial_seed = Math.seed;
		startSessionJunior();
	}
}



void easterEggCallBackAB(){
	initializePlayers(curSessionGlobalVar.players,curSessionGlobalVar); //need to redo it here because all other versions are in case customizations
	if(simulationMode == true){
		intro();
	}else{
		load(curSessionGlobalVar.players, curSessionGlobalVar.guardians); //in loading.js
	}
}



//callback is optional, only tournament will call
void startSession(callBack){
	nonRareSessionCallback = callBack;
	//print("start session");
	querySelector("#story").html("");
	curSessionGlobalVar = new Session(initial_seed);
	reinit();
	createScenesForSession(curSessionGlobalVar);
	//initPlayersRandomness();
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	curSessionGlobalVar.makeGuardians(); //after entry order established
	if(getParameterByName("royalRumble")  == "true"){
		debugRoyalRumble();
	}

	if(getParameterByName("lollipop")  == "true"){
		tricksterMode();
	}

	if(getParameterByName("robot")  == "true"){
		roboMode();
	}

	if(getParameterByName("sbajifier")  == "true"){
		sbahjMode();
	}

	if(getParameterByName("babyStuck")  == "true"){
		babyStuckMode();
	}
	checkEasterEgg(easterEggCallBackAB);

}



void restartSession(){
	//print("restart session");
	querySelector("#story").html("");
	//window.scrollTo(0, 0);  jarring for AB to go up and down over and over
	intro();
}






void shareableURL(){
	String str = '<a href ;= "index2.html?seed=' +initial_seed +'">Shareable URL </a> &nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp <a href ;= "index2.html">Random Session URL </a> ';
	querySelector("#seedText").html(str);
}





void renderScratchButton(session){
	//print("rendering scratch button, i.e. setting need to scratch to true.");
	needToScratch = true;

}



void scratchAB(session){
	//print("rendering scratch button, i.e. setting need to scratch to false.");
	needToScratch = false;
	//treat myself as a different session that scratched one?
	var living = findLivingPlayers(session.players);
	if(!session.scratched && living.length > 0 && !tournamentMode){
		//print("scartch");
		//alert("AB sure loves scratching!");
		session.scratchAvailable = true;
		session.pleaseIgnoreThisSessionAB = true;
		summarizeSessionNoTimeout(session);
		scratch(); //not user input, just straight up do it.
	}else{
		//print("no scratch");
		session.scratchAvailable = false;
		summarizeSession(session);
	}
}



void scratchConfirm(){
	var scratchConfirmed = confirm("This session is doomed. Scratching this session will erase it. A new session will be generated, but you will no longer be able to view this session. Is this okay?");
	if(scratchConfirmed){
		scratch();
	}
}



void reinit(){
	//print("reinit");
	available_classes = classes.slice(0);
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
	available_aspects = available_aspects.concat(required_aspects.slice(0));
	curSessionGlobalVar.reinit();
}




void tick(){
	//print("tick " + curSessionGlobalVar.timeTillReckoning + curSessionGlobalVar.doomedTimeline);
	if(curSessionGlobalVar.timeTillReckoning > 0 && !curSessionGlobalVar.doomedTimeline){
		setTimeout((){
			curSessionGlobalVar.timeTillReckoning += -1;
			processScenes2(curSessionGlobalVar.players,curSessionGlobalVar);
			tick();
		},repeatTime); //or availablePlayers.length * *1000?
	}else{

		reckoning();
	}
}



dynamic reckoning(){
	var s = new Reckoning(curSessionGlobalVar);
	s.trigger(curSessionGlobalVar.players);
	s.renderContent(curSessionGlobalVar.newScene());

	if(!curSessionGlobalVar.doomedTimeline){
		reckoningTick();
	}else{
		if(needToScratch){
			scratchAB(curSessionGlobalVar);
			return null;
		}
		////print("doomed timeline prevents reckoning");
		var living = findLivingPlayers(curSessionGlobalVar.players);
		if(curSessionGlobalVar.scratched || living.length == 0){ //can't scrach so only way to keep going.
			//print("doomed scratched timeline");
			summarizeSession(curSessionGlobalVar);
		}
	}
}



dynamic reckoningTick(){
	//print("reckoning tick " + curSessionGlobalVar.timeTillReckoning + curSessionGlobalVar.doomedTimeline);
	if(curSessionGlobalVar.timeTillReckoning > -10){
		setTimeout((){
			curSessionGlobalVar.timeTillReckoning += -1;
			processReckoning2(curSessionGlobalVar.players,curSessionGlobalVar);
			reckoningTick();
		},repeatTime);
	}else{
		var s = new Aftermath(curSessionGlobalVar);
		//print("about to trigger aftermath");
		s.trigger(curSessionGlobalVar.players);
		s.renderContent(curSessionGlobalVar.newScene());
		//print("aftermath rendered");
		//after math can call a scratch.


		//summarizeSession(curSessionGlobalVar);
		//for some reason whether or not a combo session is available isn't working? or combo isn't working right in this mode?
		//print("checking if i should do summaries");
		if(curSessionGlobalVar.makeCombinedSession == true){
			processCombinedSession();  //make sure everything is done rendering first
		}else{
			if(needToScratch){
				scratchAB(curSessionGlobalVar);
				return null;
			}
			var living = findLivingPlayers(curSessionGlobalVar.players);
			if(curSessionGlobalVar.won || living.length == 0 || curSessionGlobalVar.scratched){
				//print("victory or utter defeat");
				summarizeSession(curSessionGlobalVar);
			}
		}


	}

}










/*

                          ```````   `                 `  ``   `                        ```````                           `
                      ```` `   `   ````           `````   `   `````               ````  `   `` ````                ````  `   ``` `
                   ```               ````        ```             ````           ```                ```          ```             ````
                  ``                   ```      ``                 ```         ```                  ```        ```                ``
           `````..``.`..`````````.``.``-``.``..`..``.```.``..``.``.``.``.``.``-`.-``.``.`..``.``.``..`..``.``.``.```..``.``..`..````..````
           `.-............-..-...-.....-........................................................................-.......................-.`
           `.-..........................................................................................................................-.`
           `......:-....-::::::::::----:++++++++++++++oo+++::::::::::::::...::::::::::::::---------::::::::::::::::::::::::::-....-:......`
           `.-..../.                 -ohddddddddddddddddddhh+`           `.`                                                      ./....-.`
           `......+.              .+yhddddddddddddddddmmmmmddy.          `.`                            `     `                   .+......`
       `````.-....+.           `:shddddddddddddddddmNNNNNNNNmdy.         `.``.+o+.`  `.oo/.           .sh   .sh                   .+....-.` ```
     ```   `......+.         -ohdddddddddddddddmmNNNNNNNNNNNNmdy`        `.`  +d+      sd:             yd    yd                   .+......`   ```
     ```   `.:....+.         .yddddddddddddmmddNNNNmshNNNNmmNNmdo        `.`  +d+      sd-    ---:.    yd    yd    `---:.         .+....:.`    ```
    ```    `......+-          `+hdddddddddms:-hNdyo.``:shmN+omNdh-       `.`  +do------yd-  -s.``-ho   yd    yd   /o```-ss`       -+......`    ```
    ```    `.-....+:            .ohddddddy-``.:-.````````.-:`-NNdo       `.`  +d+``````yd-  yy:::://`  yd    yd  -h:    -do       :+....-.`    ```
     ```   `......+-              .+hdddds```````````````````.NNmh.      `.`  +d+      sd-  yh.    .`  yd    yd  :do    `d+       -+......`    ```
     ```   `.-..../.                .sddddy-`````````````````+Nmdo`      `.`  odo      yd:  -yho//+:   yd    yd   +h/` `/o`  /o.  ./....-.`    ``
       `````....../.                 -yddddh/```````````````/dyo-        `.``.:::.`  `.::-`  `-//:.   .::.  .::.   .::-..    -/`  ./......` ````
        ````......+.                /hddddddds:``````````.-/:.`          `.`                                                      .+......````
           `......+.               -ddmddddddddo-..-//+ohms              `.`                                                      .+......`
           `.-....+.              -hdNmddddddddddhhdddddyNh              `.`                                                      .+....-.`
           `-.....+.           .-ohddmdddddddddddhhdddddso:              `.`                                                      .+.....-`
          ``......+.          .ohdddddddddddddddhs/ddddddh:              `.`                                                      .+......`
        ````......+.         ```:hdddddddddddddh+--/hdddddh-             `.`                                                      .+......`````
      ```  `......+-      ``````.hddddddddddddho....+dddddy`             `.`                                                      -+......`  ```
     ````  `.:...-+:   ``````` `odddddddddddddo/-..-+sdds/.``            `.`                                                      :+-...:.`   ```
     ```   `....../-`````````   :sssssssyyyyyys+o++o+syyo `````          `.`               ````````````````                       -/......`    ``
     ```   `........````````````--------:::::::::::::::::.````````````````.````````````````````````````````````````````````````````.......`    ``
     ```   `....../```````      -+syyyhhhhhhhhhddddddhyo/.    ```        `.`                                                      `+......`   ```
      ``   `.....-+`   `````       ``.shdddddddddddddo         ```       `.`                                                      `+-.....`   ```
       ``` `.....-+`      `````   ````-/hddddddddddddh-         ```      `.`                                                      `+-.....`  ``
         ```.-...-+`          ````````..:oddddddddddddh.         ```     `.`                                                      `+-...-.```
           `.....-+.                 :shyddddddddddddddy.         ```    `.`                                                      .+-.....`
           `.-...-+.                 sddddddddddddddddddy.        ```    `.`                                                      .+-...-.`
           `......+`                 ydddddddddddddddddddh.        ```   `.`                                                      `+......`
        ````......+`                -hydddddddddddddddddddy`        ``   `.`                                                      `+......`````
      ```  `......+`                +hsdddddddddddddddddddds`        ``  `.`                                                      `+......`  ````
     ```   `.....-+`                +y+hddddddddddddddddddddo         `` `.`                                                      `+-.....`   ```
     ```   `.-...-+`                ys+yddddddddddddddddddddd/         ` `.`                                                      `+-...-.`    ```
     ```   `.....-+`               -d++sdddddddddddddddddddddh-        ```.`                                                      `+-.....`    ```
     ```   `:....-+`               -s++ohhhhhddhdddddddhhhhyso+        ` `..`                                                     `+-....:`   ```
      ``   `.....-+`                .++++++oooo-::::/oooo++++++.         `..`                                                     `+-.....`   ```
       ````..-...:+`                -+++++++++/      :+++++++++/         `.`                                                      `+:...-.` ````
        ```......-+.                -+++++++++/       /+++++++++.        `.`                                                      .+-......```
           `.-...:+.                -+++++++++/       `+++++++++/        `.`                                                      .+:...-.`
           `.-...-+-                -+++++++++/        :+++++++++`       `.`                                                      -+-...-.`
           ......./:...--:::::::::--://///////:......--://///////::::::::...::::::::::::::--------:::::::::::::::::::::::::::--...:/.......
           ..-..........................................................................................................................-..
           ..-........-...-..-..................................................................................-..............-........-..
           `````-``.``.```.`````..`..`..``-``-``-``..``.```-``.```.``.`..``.`..`..`..`..`.``..`..``-``.``.``..``.```-```.``-```.``.``-`````
*/


//Hello!!! This is 100% a legit tactic to passing this challenge. Win through programming knowledge, win through whatever. 10 points to you for HAX0Ring knowledge.
// ...but...aren't you curious how to pass it for real? (or is it obvious to you now that you've seen this?)
//want a spoiler? I'll put the answer all the way on the bottom of the page.
void checkPasswordAgainstQuip(summary){
	var quip = getQuipAboutSession(summary);
	if(quip == "Everything went better than expected."){
		alert("!!!");
		loadEasterEggs();
	}else{
		alert("AB: You have the right idea, but you're not getting it. This was: '" + quip + "', not 'better than expected'.");
	}
}



void avatarCarousel(){
	var possibleAvatars = ["images/CandyAuthorBot.png","images/ab_doll.jpg","images/trickster_author_transparent.png","images/ab_guide_sprite.png","images/trickster_artist_transparent.png","images/jr_sprite.png"];
  var possibleAvatars = possibleAvatars.concat(["images/misc/fanArt/ABFanArt/reDead-ITA.png","images/misc/fanArt/ABFanArt/chaoticConvergence.jpeg", "pumpkin.png", "images/misc/fanArt/ABFanArt/artificialArtificer.png","images/misc/fanArt/ABFanArt/Makin.png","images/misc/fanArt/ABFanArt/waltzingOphidan.png"]);
	querySelector("#avatar").attr("src",getRandomElementFromArray(possibleAvatars));
	setTimeout(avatarCarousel,10000);
}



void loadEasterEggs(){
	$.ajax({
	  url: "easter_eggs.txt",
	  success:((data){
		 querySelector("#easter_eggs").html(data);
		  querySelector("#pw_container").html("");
			avatarCarousel();
		  if(getParameterByName("lollipop")  == "true"){
			querySelector("#avatar").attr("src","images/CandyAuthorBot.png");

		  }
	  }),
	  dataType: "text"
	});
}



dynamic processCombinedSession(){
	initial_seed = Math.seed;
	var newcurSessionGlobalVar = curSessionGlobalVar.initializeCombinedSession();
	if(newcurSessionGlobalVar){
		print("doing a combo session");
		curSessionGlobalVar = newcurSessionGlobalVar;
		querySelector("#story").append("<br><Br> But things aren't over, yet. The survivors manage to contact the players in the universe they created. Time has no meaning between universes, and they are given ample time to plan an escape from their own Game Over. They will travel to the new universe, and register as players there for session " + curSessionGlobalVar.session_id + ". ");
		intro();
	}else{
		print("can't combo, can't scratch. just do next session.");
		needToScratch = false; //can't scratch if skaiai is a frog
		curSessionGlobalVar.makeCombinedSession == false
		summarizeSession(curSessionGlobalVar);
		/*var living = findLivingPlayers(curSessionGlobalVar.players);
		if(curSessionGlobalVar.scratched || living.length == 0){
			//print("not a combo session");
			curSessionGlobalVar.makeCombinedSession == false
			summarizeSession(curSessionGlobalVar);
		}else{
			if(needToScratch){
				//scratchAB(curSessionGlobalVar);
				needToScratch = false; //can't scratch if skaiai is a frog
				curSessionGlobalVar.makeCombinedSession == false
				summarizeSession(curSessionGlobalVar);
				return null;
			}
		}*/
	}

}





dynamic summarizeSession(session){
	//print("summarizing: " + curSessionGlobalVar.session_id + " please ignore: " +curSessionGlobalVar.pleaseIgnoreThisSessionAB);
	//don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
	if(sessionsSimulated.indexOf(session.session_id) != -1){
		////print("should be skipping a repeat session: " + curSessionGlobalVar.session_id);

		//return;
	}
	sessionsSimulated.push(curSessionGlobalVar.session_id);

	var sum = curSessionGlobalVar.generateSummary();
	if(nonRareSessionCallback) return nonRareSessionCallback(sum); //it will handle calling next session.
	querySelector("#story").html("");
	allSessionsSummaries.push(sum);
	sessionSummariesDisplayed.push(sum);
	//printSummaries();  //this slows things down too much. don't erase and reprint every time.
	var str = sum.generateHTML();
	debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(sum) + "</font><Br>" );
	debug(str);
	printStats();
	numSimulationsDone ++;
	initial_seed = Math.seed; //child session
	if(numSimulationsDone >= numSimulationsToDo){
		querySelector("#button").prop('disabled', false);
		if(!getParameterByName("robot")){
			if(pwMode){
				checkPasswordAgainstQuip(sum);
			}else{
				alert("Notice: should be ready to check more sessions.");
			}
			querySelector("input[name='filter']").each((){;
					querySelector(this).prop('disabled', false);
			});

		}
		return;
	}else{
		setTimeout((){
			//print("setting timeout for new seed");
			//var tmp = getRandomSeed();
			//Math.seed = tmp;
			//doomedTimelineReasons = [];

			startSession();
		},repeatTime*2); //since ticks are on time out, one might hit right as this is called, don't want that, cause causes players to be dead or godtier at start of next session
	}
}




dynamic summarizeSessionNoTimeout(session){
	//print("no timeout summarizing: " + curSessionGlobalVar.session_id);
	//don't summarize the same session multiple times. can happen if scratch happens in reckoning, both point here.
	if(sessionsSimulated.indexOf(session.session_id) != -1){
		////print("should be skipping a repeat session: " + curSessionGlobalVar.session_id);

		//return;
	}
	sessionsSimulated.push(curSessionGlobalVar.session_id);
	querySelector("#story").html("");
	var sum = curSessionGlobalVar.generateSummary();
	if(nonRareSessionCallback) return null; //tournament doens't support scratches.
	allSessionsSummaries.push(sum);
	sessionSummariesDisplayed.push(sum);
	//printSummaries();  //this slows things down too much. don't erase and reprint every time.
	var str = sum.generateHTML();
	debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(sum) + "</font><Br>" );
	debug(str);
	printStats();
}





//don't use a seed here
void percentBullshit(){
	var pr = 90+Math.random()*10; //this is not consuming randomness. what to do?
	querySelector("#percentBullshit").html(pr+"%");
}



//oh Dirk/Lil Hal/Lil Hal Junior, why are you so amazing?
dynamic getQuipAboutSessionJunior(){
	var quips = ["Hmmm","Yes.","Interesting!!!"];
	return getRandomElementFromArray(quips);
}



dynamic getQuipAboutSession(sessionSummary){
	String quip = "";
	var living = sessionSummary.numLiving;
	var dead = sessionSummary.numDead;
	var strongest = sessionSummary.mvp;

	if(sessionSummary.session_id == 33 || getParameterByName("nepeta")  == ":33"){
		quip += "Don't expect any of my reports on those cat trolls to be accurate. They are random as fuck. " ;
	}

	if(sessionSummary.crashedFromSessionBug){
		quip += Zalgo.generate("Fuck. Shit crashed hardcore. It's a good thing I'm a flawless robot, or I'd have nightmares from that. Just. Fuck session crashes.  Also, shout out to star.eyes: 'His palms are sweaty, knees weak, arms are heavy. There's vomit on his sweater already, mom's spaghetti'");
	}else if(sessionSummary.crashedFromPlayerActions){
		quip += Zalgo.generate("Fuck. God damn. Do Grim Dark players even KNOW how much it sucks to crash? Assholes.");
	}else if(sessionSummary.frogStatus == "Purple Frog" && sessionSummary.blackKingDead){
	    quip += "Oh my fucking god is THAT what the Grim Dark players have been trying to do. Are organics really so dumb as to not realize how very little that benefits them?";
	}else if(!sessionSummary.scratched && dead == 0 && sessionSummary.frogStatus == "Full Frog" && sessionSummary.ectoBiologyStarted && !sessionSummary.crashedFromCorruption && !sessionSummary.crashedFromPlayerActions){
		quip += "Everything went better than expected." ; //???
	}else if(sessionSummary.yellowYard == true){
		quip += "Fuck. I better go grab JR. They'll want to see this. " ;
	}else if(living == 0){
		quip += "Shit, you do not even want to KNOW how everybody died." ;
	}else  if(strongest.power > 3000){
		//alert([!sessionSummary.scratched,dead == 0,sessionSummary.frogStatus == "Full Frog",sessionSummary.ectoBiologyStarted,!sessionSummary.crashedFromCorruption,!sessionSummary.crashedFromPlayerActions ].join(","))
		quip += "Holy Shit, do you SEE the " + strongest.titleBasic() + "!?  How even strong ARE they?" ;
	}else if(sessionSummary.frogStatus == "No Frog" ){
		quip += "Man, why is it always the frogs? " ;
		if(sessionSummary.parentSession){
			quip += " You'd think what with it being a combo session, they would have gotten the frog figured out. ";
		}
	}else  if(sessionSummary.parentSession){
		quip += "Combo sessions are always so cool. " ;
	}else  if(sessionSummary.jackRampage){
		quip += "Jack REALLY gave them trouble." ;
	}else  if(sessionSummary.num_scenes > 200){
		quip += "God, this session just would not END." ;
		if(!sessionSummary.parentSession){
			quip += " It didn't even have the excuse of being a combo session. ";
		}
	}else  if(sessionSummary.murderMode == true){
		quip += "It always sucks when the players start trying to kill each other." ;
	}else  if(sessionSummary.num_scenes < 50){
		quip += "Holy shit, were they even in the session an entire hour?" ;
	}else  if(sessionSummary.scratchAvailable == true){
		quip += "Maybe the scratch would fix things? Now that JR has upgraded me, I guess I'll go find out." ;
	}else{
		quip += "It was slightly less boring than calculating pi." ;
	}

	if(sessionSummary.threeTimesSessionCombo){
		quip+= " Holy shit, 3x SessionCombo!!!";
	}else if(sessionSummary.fourTimesSessionCombo){
		quip+= " Holy shit, 4x SessionCombo!!!!";
	}else if(sessionSummary.fiveTimesSessionCombo){
		quip+= " Holy shit, 5x SessionCombo!!!!!";
	}else if(sessionSummary.holyShitMmmmmonsterCombo){
		quip+= " Holy fuck, what is even HAPPENING here!?";
	}
	return quip;
}



void foundRareSession(div, debugMessage){
	//print(debugMessage);
	String canvasHTML = "<br><canvas id;='canvasJRAB" + (div.attr("id")) +"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
	div.append(canvasHTML);

	var canvasDiv = querySelector("#canvasJRAB"+  (div.attr("id")));
	String chat = "";
  chat += "AB: Just thought I'd let you know: " + debugMessage +"\n";
	chat += "JR: *gasp* You found it! Thanks! You are the best!!!\n";
	var quips1 = ["It's why you made me.", "It's not like I have a better use for my flawless mecha-brain.", "Just doing as programmed."];
	chat += "AB: " + getRandomElementFromArrayNoSeed(quips1)+"\n" ;
	chat += "JR: And THAT is why you are the best.\n ";
	var quips2 = ["Seriously, isn't it a little narcissistic for you to like me so much?", "I don't get it, you know more than anyone how very little 'I' is in my A.I.", "Why did you go to all the effort to make debugging look like this?"];
	chat += "AB: " + getRandomElementFromArrayNoSeed(quips2)+"\n";
	chat += "JR: Dude, A.I.s are just awesome. Even simple ones. And yeah...being proud of you is a weird roundabout way of being proud of my own achievements.\n";
  var quips3 = ["Won't this be confusing to people who aren't you?", "What if you forget to disable these before deploying to the server?", "Doesn't this risk being visible to people who aren't you?"];
  chat += "AB: " + getRandomElementFromArrayNoSeed(quips3)+"\n";
	chat += "JR: Heh, I'll do my best to turn these debug messages off before deploying, but if I forget, I figure it counts as a highly indulgent author-self insert x2 combo. \n";
  chat += "JR: Oh! And I'm really careful to make sure these little chats don't actually influence the session in any way.\n";
	chat += "JR: Like maybe one day you or I can have a 'yellow yard' type interference scheme. But today is not that day.";
	drawChatABJR(canvasDiv, chat);
}



void printStatsJunior(){
	var mms = collateMultipleSessionSummariesJunior(sessionSummariesDisplayed);
	querySelector("#stats").html(mms.generateHTML());
	querySelector("#num_players").change((){
			querySelector("#num_players_text").val(querySelector("#num_players").val());
	});
}



void printStats(filters, classes, aspects){
	var mms = collateMultipleSessionSummaries(sessionSummariesDisplayed);
	//todo if corpse party mode, display corpse party and replace AB imge with corpse party AB and ABJ.
	//TODO have different divs of types of stats, most defaulted to hidden, with checkbox toggles for what you want to see.
	querySelector("#stats").html(mms.generateHTML());
	mms.wireUpCorpsePartyCheckBoxes();

	if(displayMisc)querySelector('#multiSessionSummaryMisc').show()  //memory. don't always turn off when making new ones.
	if(!displayMisc)querySelector('#multiSessionSummaryMisc').hide();

	if(displayRomance)querySelector('#multiSessionSummaryRomance').show()  //memory. don't always turn off when making new ones.
	if(!displayRomance)querySelector('#multiSessionSummaryRomance').hide();

	if(displayDrama)querySelector('#multiSessionSummaryDrama').show()  //memory. don't always turn off when making new ones.
	if(!displayDrama)querySelector('#multiSessionSummaryDrama').hide();

	if(displayEnding)querySelector('#multiSessionSummaryEnding').show()  //memory. don't always turn off when making new ones.
	if(!displayEnding)querySelector('#multiSessionSummaryEnding').hide();

	if(displayAverages)querySelector('#multiSessionSummaryAverage').show()  //memory. don't always turn off when making new ones.
	if(!displayAverages)querySelector('#multiSessionSummaryAverage').hide();

	if(displayCorpse)querySelector('#multiSessionSummaryCorpseParty').show()  //memory. don't always turn off when making new ones.
	if(!displayCorpse)querySelector('#multiSessionSummaryCorpseParty').hide();

	if(filters){
		querySelector("input[name='filter']").each((){;
			querySelector(this).prop('disabled', false);
			if(filters.indexOf(querySelector(this).val()) != -1){
				querySelector(this).prop('checked',true);
			}else{
				querySelector(this).prop('checked',false);
			}
		});

	}

	if(classes && aspects){
		querySelector("input[name='filterClass']").each((){;
			querySelector(this).prop('disabled', false);
			if(classes.indexOf(querySelector(this).val()) != -1){
				querySelector(this).prop('checked',true);
			}else{
				querySelector(this).prop('checked',false);
			}
		});

		querySelector("input[name='filterAspect']").each((){;
			querySelector(this).prop('disabled', false);
			if(aspects.indexOf(querySelector(this).val()) != -1){
				querySelector(this).prop('checked',true);
			}else{
				querySelector(this).prop('checked',false);
			}
		});

	}
}



void printSummariesJunior(){
	querySelector("#debug").html("");
	for(num i = 0; i<sessionSummariesDisplayed.length; i++){
		var ssd = sessionSummariesDisplayed[i];
		var str = ssd.generateHTML();
		debug("<br><hr><font color = 'orange'> AB: " + getQuipAboutSessionJunior() + "</font><Br>" );
		debug(str);
	}
}




void printSummaries(){
	querySelector("#debug").html("");
	for(num i = 0; i<sessionSummariesDisplayed.length; i++){
		var ssd = sessionSummariesDisplayed[i];
		var str = ssd.generateHTML();
		debug("<br><hr><font color = 'red'> AB: " + getQuipAboutSession(ssd) + "</font><Br>" );
		debug(str);
	}
}






void checkDoomedTimelines(){
	////print("check");
	for(var i= 0; i<curSessionGlobalVar.doomedTimelineReasons.length; i ++){
		if(curSessionGlobalVar.doomedTimelineReasons[i] != "Shenanigans"){
			//alert("found an interesting doomed timeline" + doomedTimelineReasons[i]);
			return;
		}
	}
	if(curSessionGlobalVar.doomedTimelineReasons.length > 1){
	}
}



void callNextIntroWithDelay(player_index){
	if(player_index >= curSessionGlobalVar.players.length){
		tick();//NOW start ticking
		return;
	}
	setTimeout((){
		var s = new Intro(curSessionGlobalVar);
		var p = curSessionGlobalVar.players[player_index];
		var playersInMedium = curSessionGlobalVar.players.slice(0, player_index+1); //anybody past me isn't in the medium, yet.
		s.trigger(playersInMedium, p);
		s.renderContent(curSessionGlobalVar.newScene(),player_index); //new scenes take care of displaying on their own.
		processScenes2(playersInMedium,curSessionGlobalVar);
		player_index += 1;
		callNextIntroWithDelay(player_index);
	},  repeatTime);  //want all players to be done with their setTimeOuts players.length*1000+2000
}




void intro(){
	//print("intro");
	curSessionGlobalVar.pleaseIgnoreThisSessionAB = false;
	callNextIntroWithDelay(0);
}


//the password is: Any session that AB would describe as "better than expected".  If you're in the code you could probably figure out what that means on your own.
//just doing a 'find on page' of this file will find it for you, in fact.
