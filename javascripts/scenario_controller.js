var curSessionGlobalVar;

var simulationMode = false;

var debugMode = false;

window.onload = function() {
	//debug("Be Patient, refactoring this code to match 2.0")
	startSession();
	/*
    init();
	//exileQueenInit();
	//murderModeInit();
	//voidLeaderInit();
	if(!debugMode){
		randomizeEntryOrder();
	}

  if(!debugMode){
  	introducePlayers();

  	//TODO random tick until reckoning.

  	//experiment with shorter sessions. does it make the chance of failure greater? don't want so many words.
  	//max of 50 is enough, 30 seems to not let good ending happen?
  	for(var i = 0; i<getRandomInt(10,30); i++){
  		if(!doomedTimeline){ //TODO (if it's a doomed timeline, figure out why and prevent it (did leader permadie without ectobiology happening or last player entering?)
  			tick();
  		}
  	}

  	introduceReckoning();
  	reckoningStarted = true;
  	//all reckonings are the same length???
  	for(var i = 0; i<10; i++){
  		if(!doomedTimeline){
  			reckoningTick();
  		}
  	}

  	if(!doomedTimeline){
  		conclusion();
  	}
}else{
  for(i=0;i<18;i++){
    debugLevelTheHellUp();
  }
}
*/
};


function reinit(){
	available_classes = classes.slice(0);
	available_aspects = nonrequired_aspects.slice(0); //required_aspects
	available_aspects = available_aspects.concat(required_aspects.slice(0));
	curSessionGlobalVar.available_scenes = curSessionGlobalVar.scenes.slice(0);  //was forgetting to reset this, so scratched players had less to do.
}


function startSession(){
	curSessionGlobalVar = new Session(initial_seed)
	createScenesForSession(curSessionGlobalVar);
	reinit();
	//initPlayersRandomness();
	curSessionGlobalVar.makePlayers();
	curSessionGlobalVar.randomizeEntryOrder();
	//authorMessage();
	//curSessionGlobalVar.makeGuardians(); //after entry order established
	introducePlayers();
	
	for(var i = 0; i<getRandomInt(10,30); i++){
  		if(!curSessionGlobalVar.doomedTimeline){ //TODO (if it's a doomed timeline, figure out why and prevent it (did leader permadie without ectobiology happening or last player entering?)
  			tick();
  		}
  	}

  	introduceReckoning();
  	curSessionGlobalVar.reckoningStarted = true;
  	//all reckonings are the same length???
  	for(var i = 0; i<10; i++){
  		if(!curSessionGlobalVar.doomedTimeline){
  			reckoningTick();
  		}
  	}

  	if(!curSessionGlobalVar.doomedTimeline){
  		conclusion();
  	}
	
}

function tick(){
	$("#story").append(processScenes(curSessionGlobalVar.players,curSessionGlobalVar));
}

function reckoningTick(){
	$("#story").append(processReckoning(curSessionGlobalVar.players,curSessionGlobalVar));
}





function printPlayers(){
	for(var i = 0; i<players.length; i++){
		$("#story").append(players[i].title() + " in the " + players[i].land +"<br>");
	}
}

function indexToWords(i){
	var words = ["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth",];
	return words[i];
}

function introduceReckoning(){
	var intro = " The reckoning has begun.  The Black King has defeated his Prospitian counterpart, initiating a meteor storm to destroy Skaia. ";
	var leader = getLeader(curSessionGlobalVar.players);
	if(curSessionGlobalVar.ectoBiologyStarted){
		intro += " Remember those random baby versions of the players the " + leader.htmlTitle() + " made? " ;
		intro += " Yeah, that didn't stop being a thing that was true. ";
		intro += " It turns out that those babies ended up on the meteors heading straight to Skaia. "
		intro += " And to defend itself, Skaia totally teleported those babies back in time, and to Earth. "
		intro += "We are all blown away by this stunning revelation.  Wow, those babies were the players? Really?  Like, a paradox?  Huh. "
	}else if(!curSessionGlobalVar.ectoBiologyStarted && leader.aspect == "Time" &&!leader.dead){
		curSessionGlobalVar.ectoBiologyStarted = true;
		intro += " Okay. Don't panic. But it turns out that the " + leader.htmlTitle() + " completly forgot to close one of their time loops. ";
		intro += " They were totally supposed to take care of the ectobiology. It's cool though, they'll just go back in time and take care of it now. ";
		intro += " They warp back to the present in a cloud of clocks and gears before you even realize they were gone. See, nothing to worry about. ";
	}
	else{
		intro += " So. I don't know if YOU know that this was supposed to be a thing, but the " + leader.htmlTitle();
		intro += " was totally supposed to have taken care of the ectobiology. ";
		intro += " They didn't. They totally didn't.  And now, it turns out that none of the players could have possibly been born in the first place. ";
		intro += " Textbook case of a doomed timeline.  Apparently the Time Player ";
		if(findAspectPlayer(curSessionGlobalVar.players, "Time").doomedTimeClones >0){
			intro += ", despite all the doomed time clone shenanigans, ";
		}
		intro += "was not on the ball with timeline management. Nothing you can do about it. <Br><Br>GAME OVER.";
		doomedTimeline = true;
		intro += "<br><br>";
		$("#story").append(intro);
		return intro;
	}
	var living = findLivingPlayers(curSessionGlobalVar.players);
	if(living.length > 0){
		intro += " <br><br>Getting back to the King, all the players can do now is try to defeat him before they lose their Ultimate Reward. ";
		intro += " The Ultimate Reward allows the players to create a new Universe frog, and live inside of it. ";
		intro += " Without it, they'll be trapped in the Medium forever. (Barring shenanigans). ";
		intro += living.length + " players, the  " + getPlayersTitles(living) + " will fight the Dersite Royalty and try to prove themselves worthy of the Ultimate Reward. ";
	}else{
		intro += " No one is alive. <BR><BR>Game Over. ";
		var strongest = findStrongestPlayer(curSessionGlobalVar.players)
		intro += "The MVP of the session was: " + strongest.htmlTitle() + " with a power of: " + strongest.power;
	}
	intro += "<br><br>";
	$("#story").append(intro);
}

function conclusion(){
	var living = findLivingPlayers(curSessionGlobalVar.players);
	var end = living.length + " players are alive." ;
	if(living.length > 0){
		end += " The " + getPlayersTitles(living) + " fought bravely against the Black King and won. ";
		end += mournDead();
		var spacePlayer = findAspectPlayer(curSessionGlobalVar.players, "Space");
		if(spacePlayer.landLevel >= 6){
			end += " Luckily, the " + spacePlayer.htmlTitle() + " was diligent in frog breeding duties. ";
			if(spacePlayer.landLevel < 8){
				end += " The frog looks... a little sick or something, though... That probably won't matter. You're sure of it. ";
			}
			end += " The frog is deployed, and grows to massive proportions, and lets out a breath taking Vast Croak.  ";
			if(spacePlayer.landLevel < 8){
				end += " The door to the new universe is revealed.  As the leader reaches for it, a disaster strikes.   ";
				end += " Apparently the new universe's sickness manifested as its version of SBURB interfering with yours. ";
				end += " Your way into the new universe is barred, and you remain trapped in the medium.  <Br><br>Game Over.";
			}else{
				end += democracyBonus();
				end += " <Br><br> The door to the new universe is revealed. Everyone files in. <Br><Br> Thanks for Playing. ";
			}


		}else{
			end += "Unfortunately, the " + spacePlayer.htmlTitle() + " was unable to complete frog breeding duties. ";
			end += " They only got " + (spacePlayer.landLevel/10*100) + "% of the way through. ";
			end += " Who knew that such a pointless mini-game was actually crucial to the ending? ";
			end += " No universe frog, no new universe to live in. Thems the breaks. ";
			end += " If it's any consolation, it really does suck to fight so hard only to fail at the last minute. <Br><Br>Game Over.";
		}
	}else{
		end += mournDead();
		end += democracyBonus();
		end += " The players have failed. No new universe is created. Their home universe is left unfertilized. <Br><Br>Game Over. ";
	}
	var strongest = findStrongestPlayer(curSessionGlobalVar.players)
	end += "The MVP of the session was: " + strongest.htmlTitle() + " with a power of: " + strongest.power;
	$("#story").append(end);

}

function democracyBonus(){
	var ret = "";
	if(curSessionGlobalVar.democracyStrength == 0){
		return ret;
	}
	if(curSessionGlobalVar.democracyStrength > 10 && findLivingPlayers(curSessionGlobalVar.players).length > 0 ){
		ret += "The adorable Warweary Villein has been duly elected Mayor by the assembeled consorts and Carpacians. "
		ret += " His acceptance speech consists of promising to be a really great mayor that everyone loves who is totally amazing and heroic and brave. "
		ret += " He organizes the consort and Carpacians' immigration to the new Universe. ";
	}else{
		if(findLivingPlayers(players).length > 0){
			ret += " The Warweary Villein feels the sting of defeat. Although he helped the Players win their session, the cost was too great.";
			ret += " There can be no democracy in a nation with only one citizen left alive. ";
			ret += " He becomes the Wayward Vagabond, and exiles himself to the remains of the Players old world, rather than follow them to the new one.";
		}else{
			ret += " The Warweary Villein feels the sting of defeat. He failed to help the Players.";
			ret += " He becomes the Wayward Vagabond, and exiles himself to the remains of the Players' old world. ";
		}
	}
	return ret;
}

function mournDead(){
	var dead = findDeadPlayers(curSessionGlobalVar.players);
	var living = findLivingPlayers(curSessionGlobalVar.players);
	if(dead.length == 0){
		return "";
	}
	var ret = "<br><br>";
	if(living.length > 0){
		ret += " Victory is not without it's price. " + dead.length + " players are dead, never to revive. There is time for mourning. ";
	}else{
		ret += " The consorts and Carpacians both Prospitian and Dersite alike mourn their fallen heroes. ";
	}

	for(var i = 0; i< dead.length; i++){
		var p = dead[i];
		ret += " The " + p.htmlTitle() + " died " + p.causeOfDeath + ". ";
		var friend = p.getWhoLikesMeBestFromList(living);
		var enemy = p.getWhoLikesMeLeastFromList(living);
		if(friend){
			ret += " They are mourned by the" + friend.htmlTitle() + ". ";
		}else if(enemy){
			ret += " The " +enemy.htmlTitle() + " feels awkward about not missing them at all. ";
		}
	}
	ret += "<Br><Br>"
	return ret;

}

function introducePlayers(){
	for(var i = 0; i<curSessionGlobalVar.players.length; i++){
		var p = curSessionGlobalVar.players[i];
		var playersInMedium =curSessionGlobalVar. players.slice(0, i+1); //anybody past me isn't in the medium, yet.
		var intro = "The " + p.htmlTitle() + " enters the game " + indexToWords(i) + ". ";
		if(i == 0){
			intro += " They are definitely the leader. ";
			p.leader = true;
		}
		if(p.godDestiny){
			intro += " They appear to be destined for greatness. ";
		}
		intro += " They boggle vacantly at the " + p.land + ". ";

		for(var j = 0; j<p.relationships.length; j++){
			var r = p.relationships[j];
			if(r.type() != "Friends" && r.type() != "Rivals"){
				intro += "They are " + r.description() + ". ";
			}
		}
		curSessionGlobalVar.kingStrength = curSessionGlobalVar.kingStrength + 20;
		if(curSessionGlobalVar.queenStrength > 0){
			curSessionGlobalVar.queenStrength = curSessionGlobalVar.queenStrength + 10;
		}
		if(disastor_prototypings.indexOf(p.kernel_sprite) != -1) {
			curSessionGlobalVar.kingStrength = curSessionGlobalVar.kingStrength + 200;
			if(curSessionGlobalVar.queenStrength > 0){
				curSessionGlobalVar.queenStrength = curSessionGlobalVar.queenStrength + 100;
			}
			intro += " A " + p.kernel_sprite + " fell into their kernel sprite just before entering. ";
			intro += " It's a good thing none of their actions here will have serious longterm consequences. ";
		}else if(fortune_prototypings.indexOf(p.kernel_sprite) != -1){
			intro += " Prototyping with the " + p.kernel_sprite + " just before entering the Medium would prove to be critical for later success. "
		}else{
			intro += " They managed to prototype their kernel with a " + p.kernel_sprite + ". ";
		}
		intro += isThereMeetup(playersInMedium);
		intro += "<br><br>";
		$("#story").append(intro);
		//scenes can happen even if all players aren't in medium yet.
		$("#story").append(processScenes(playersInMedium,curSessionGlobalVar));
	}
}

//can meetup with anyone with a lower index than me.
function isThereMeetup(playersInMedium){
	var meetup = "";
	var me = playersInMedium[playersInMedium.length-1];
	//don't loop on yourself.
	for(var i =0; i<playersInMedium.length-1; i++){
		if(Math.seededRandom() > 0.90){
			var you = playersInMedium[i];
			me.increasePower();
			you.increasePower();
			me.checkBloodBoost([you]);
			you.checkBloodBoost([me]);
			var r1 = me.getRelationshipWith(you);
			r1.moreOfSame();
			var r2 = you.getRelationshipWith(me);
			r2.moreOfSame();
			if(r2.value > 0 && r1.value > 0){
				meetup += " The " + you.htmlTitle() + " shows up at " + me.shortLand() + " and helps them out with a few low level quests. ";
			}else if(r2.value < 0){
				meetup += " The " + you.htmlTitle() + " shows up at "  + me.shortLand() + " to brag about their higher levels. ";
			}else{
				meetup += " The " + you.htmlTitle() + " wanders over to " + me.shortLand() + " on accident. ";
			}

			meetup += getRelationshipFlavorText(r1,r2, me, you);

			return meetup; //only one meetup per intro

		}
	}
	return meetup;
}



/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * Using Math.round() will give you a non-uniform distribution!
 */
function getRandomInt(min, max) {
    return Math.floor(Math.seededRandom() * (max - min + 1)) + min;
}
