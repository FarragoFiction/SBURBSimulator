

/*
	Each of these important events have:
	a subtype (which is just the classname)
	a session
	a player (optional, whoever died, or went murder mode, or whatever)
	a mvp value (at time of event creation) keeps the important event referenceing the right timeline
	a importanceRating
	a alternateTimeline function.
	a humanLabel function.  instead of PlayerDiedButCouldGodTier it would be "The Heir of Life died with a living dream self. Make them GodTier."
*/

//TODO, maybe allow them to prevent existing god tiers?

//screw fate, we have a time player here, and obviously this fate leads to a doomed timeline anyways and thus is changeable.
//have alternate timeline change based on it being a dreamself that's dying versus an unsmooched regular self.
//if i ever implmeent moon destruction, will need to refactor this, unless want to have time shenanigans. (god tier time players can take dying player to before moon was destroyed???)
class PlayerDiedButCouldGodTier {
	var session;
	num importanceRating = 9;
	var mvp_value;	var player = makeRenderingSnapshot;
	var doomedTimeClone;
	num timesCalled = 0;
	var secondTimeClone = null;  //second time clone undoes first undo
	//print("Created GodTier opportunity, for: " + this.player.title());

	


	PlayerDiedButCouldGodTier(this.session, this.mvp_value, this.player, this.doomedTimeClone) {}


	dynamic humanLabel(){
		String ret = "";
		ret += "Have the " + this.player.htmlTitle() + " go God Tier instead of dying forever. ";
		return ret;
	}
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.currentHP = this.doomedTimeClone.hp;

			if(this.secondTimeClone){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.currentHP = this.secondTimeClone.hp;
				return undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			//print("times called : " + this.timesCalled);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + this.player.htmlTitleBasic() + " needs to go God Tier now. ";
			narration += " No matter what 'fate' says. ";
			narration += " They scoop the corpse up and vanish with it in a cloud of gears, depositing it instantly on the " + this.player.htmlTitleBasic() + "'s ";
			if(this.player.isDreamSelf == true){
				narration += "sacrificial slab, where it glows and ascends to the God Tiers with a sweet new outfit";
			}else{
				narration += " quest bed. The corpse glows and rises Skaiaward. ";
				narration +="On " + this.player.moon + ", their dream self takes over and gets a sweet new outfit to boot.  ";
			}
			narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
			div.append(narration);

			var divID = (div.attr("id")) + "_alt_" + this.player.chatHandle;
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(dSpriteBuffer,this.player);
			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);

			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			player.makeGodTier();

			var divID2 = (div.attr("id")) + "_alt_god" + player.chatHandle;
			String canvasHTML2 = "<br><canvas id;='canvas" + divID2+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML2);
			var canvasDiv2 = querySelector("#canvas"+ divID2);
			List<dynamic> players = [];
			players.push(player);
			drawGetTiger(canvasDiv2, players,repeatTime);
			return true;
	}

}




class PlayerDiedForever {
	var session;
	var secondTimeClone = null;  //second time clone undoes first undo
	var mvp_value;
	num importanceRating = 5;	var player = makeRenderingSnapshot;
	var doomedTimeClone;
	num timesCalled = 0;	


	PlayerDiedForever(this.session, this.mvp_value, this.player, this.doomedTimeClone) {}


	dynamic humanLabel(){
		String ret = "Make the " + this.player.htmlTitle() + " not permanently dead.";
		return ret;
	}
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.currentHP = this.doomedTimeClone.hp;
			if(this.secondTimeClone) this.secondTimeClone.dead = false;
			if(this.secondTimeClone) this.secondTimeClone.currentHP = this.secondTimeClone.hp;
			if(this.secondTimeClone){
				return undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " +player.htmlTitleBasic() + " needs to be protected. ";
			narration += " No matter what 'fate' says. ";
			narration += " They sacrifice their life for the " + player.htmlTitleBasic() + ". ";


			div.append(narration);

			player.makeAlive();
			player.sanity += -0.5;

			this.doomedTimeClone.makeDead("sacrificing themselves through a YellowYard");

			var divID = (div.attr("id")) + "_alt_" + player.chatHandle;
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSpriteTurnways(dSpriteBuffer,player);
			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);

			var alphaTimePlayer = findAspectPlayer(this.session.players, "Time");
			removeFromArray(this.doomedTimeClone, alphaTimePlayer.doomedTimeClones);   //DEAD
			this.session.afterLife.addGhost(this.doomedTimeClone);
			return true;
	}

}



class PlayerWentGrimDark {
	var session;
	var mvp_value;
	num importanceRating = 7;	var player = makeRenderingSnapshot;
	num timesCalled = 0;
	var doomedTimeClone;
	var secondTimeClone = null;  //second time clone undoes first undo

	


	PlayerWentGrimDark(this.session, this.mvp_value, this.player, this.doomedTimeClone) {}


	dynamic humanLabel(){
		String ret = "Prevent the " + this.player.htmlTitle() + " from going Grimdark.";
		return ret;
	}
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.currentHP = this.doomedTimeClone.hp;

			if(this.secondTimeClone){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.currentHP = this.secondTimeClone.hp;
				return undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + player.htmlTitleBasic() + " needs to be calmed the fuck down. ";
			narration += " No matter what 'fate' says. ";
			narration += " They spend some time letting the  " + player.htmlTitleBasic() + " vent. Hug bumps are shared. ";
			if(this.doomedTimeClone.isTroll == true || player.isTroll == true){
				narration += "The fact that the " + this.doomedTimeClone.htmlTitleBasic() + " is doomed makes this especially tragic, forestalling any romance this might have otherwise had. ";
			}
			narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
			div.append(narration);
			player.sanity += -10;


			var divID = (div.attr("id")) + "_alt_" + player.chatHandle;
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSpriteTurnways(dSpriteBuffer,player);

			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
			return true;
	}

}



class PlayerWentMurderMode {
	var session;
	var mvp_value;
	num importanceRating = 7;	var player = makeRenderingSnapshot;
	num timesCalled = 0;
	var doomedTimeClone;
	var secondTimeClone = null;  //second time clone undoes first undo

	


	PlayerWentMurderMode(this.session, this.mvp_value, this.player, this.doomedTimeClone) {}


	dynamic humanLabel(){
		String ret = "Prevent the " + this.player.htmlTitle() + " from going into Murder Mode.";
		return ret;
	}
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.currentHP = this.doomedTimeClone.hp;

			if(this.secondTimeClone){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.currentHP = this.secondTimeClone.hp;
				return undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + player.htmlTitleBasic() + " needs to be calmed the fuck down. ";
			narration += " No matter what 'fate' says. ";
			narration += " They spend some time letting the  " + player.htmlTitleBasic() + " vent. Hug bumps are shared. ";
			if(this.doomedTimeClone.isTroll == true || player.isTroll == true){
				narration += "The fact that the " + this.doomedTimeClone.htmlTitleBasic() + " is doomed makes this especially tragic, forestalling any romance this might have otherwise had. ";
			}
			narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
			div.append(narration);
			player.sanity += -10;


			var divID = (div.attr("id")) + "_alt_" + player.chatHandle;
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSpriteTurnways(dSpriteBuffer,player);

			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
			return true;
	}

}



//grab ring before this can happen.
class JackPromoted {
	var session;
	var mvp_value;
	num importanceRating = 10;
	num timesCalled = 0;
	var doomedTimeClone;
	var secondTimeClone = null;  //second time clone undoes first undo

	


	JackPromoted(this.session, this.mvp_value, this.doomedTimeClone) {}


	dynamic humanLabel(){
		String ret = "Prevent Jack from obtaining the Black Queen's RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD.";
		return ret;
	}
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.currentHP = this.doomedTimeClone.hp;

			if(this.secondTimeClone){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.currentHP = this.secondTimeClone.hp;
				return undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the Black Queen's RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD needs to be destroyed. Immediately.";
			narration += " No matter what 'fate' says. Jack Noir immediately begins flipping out, but the RING is stolen before he can do anything. ";
			narration +=  "The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes with the RING in a cloud of gears to join the final battle.";
			div.append(narration);
			this.session.destroyBlackRing();

			var divID = (div.attr("id")) + "_alt_jack_promotion";
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone);
			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			return true;
	}

}



//if knight, directly help, if not but knight alive, force them to help. else, indirect help
//if knight of space (most common reason this is called, indirect help)
class FrogBreedingNeedsHelp {
	var session;
	var mvp_value;
	num timesCalled = 0;
	var doomedTimeClone;
	num importanceRating = 2;  //really, this is probably the least useful thing you could do. If this is the ONLY thing that went wrong, your session is going great.
	num timesCalled = 0;
	var secondTimeClone = null;  //second time clone undoes first undo
  //print("creating frog needs help event, seed is: " + Math.seed);
	


	FrogBreedingNeedsHelp(this.session, this.mvp_value, this.doomedTimeClone) {}


	dynamic humanLabel(){
		var spacePlayer = findAspectPlayer(this.session.players, "Space");
		String ret = "Help the " + spacePlayer.htmlTitleBasic() + " complete frog breeding duties.";
		return ret;
	}
	bool alternateScene(div){
			var spacePlayer = findAspectPlayer(this.session.players, "Space");
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.currentHP = this.doomedTimeClone.hp;

			if(this.secondTimeClone){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.currentHP = this.secondTimeClone.hp;
				return undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + spacePlayer.htmlTitleBasic() + " needs to be helped with their Frog Breeding duties. ";
			narration += " No matter what anybody says about time travel frog breeding being an overly elaborate and dangerous undertaking.  Desperate times, Desperate measures. ";
			if(this.doomedTimeClone.class_name == "Knight"){
				narration += " Luckily they were SUPPOSED to be helping breed the frog in the first place, so it's just a matter of making enough stable time loops to make a huge dent in the process. ";
				spacePlayer.landLevel += 10;
			}else{
				narration += " Unfortunately they are not a Knight, and thus are banned from helping breed frogs directly.  But with a little creativity and a LOT of stable time loops they manage to indirectly help a huge amount. ";
				spacePlayer.landLevel += 8;
			}
			narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
			div.append(narration);

			var divID = (div.attr("id")) + "_alt_" + spacePlayer.chatHandle;
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSpriteTurnways(dSpriteBuffer,spacePlayer);

			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
			//print("done helping frog a scene, seed is at: " + Math.seed);
			return true;
	}


}




class PlayerEnteredSession {
	var session;
	var mvp_value;
	num timesCalled = 0;	var player = makeRenderingSnapshot;
	var doomedTimeClone;
	num importanceRating = 5;
	num timesCalled = 0;
	var secondTimeClone = null;  //second time clone undoes first undo

	


	PlayerEnteredSession(this.session, this.mvp_value, this.player, this.doomedTimeClone) {}


	dynamic humanLabel(){
		String ret = "Kill the " + this.player.htmlTitle() + " before they enter the session.";
		return ret;
	}
	bool alternateScene(div){
		this.timesCalled ++;
		this.doomedTimeClone.dead = false;
		this.doomedTimeClone.currentHP = this.doomedTimeClone.hp;

			if(this.secondTimeClone){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.currentHP = this.secondTimeClone.hp;
				return undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + player.htmlTitleBasic() + " needs to die.  You do not even want to know how long it took them to get back to earth, and then time-travel to before the" +  player.htmlTitleBasic() + " entered the session. They are commited to this. ";
			narration += " No matter what 'fate' says. ";

			narration +=  "After a brief struggle, the doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
			div.append(narration);
			player.dead = true;
			player.makeDead("apparantly displeasing the Observer.");
			this.doomedTimeClone.victimBlood = player.bloodColor;


			var divID = (div.attr("id")) + "_alt_" + player.chatHandle;
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(dSpriteBuffer,player);

			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
			return false; //let the original scene happen as well.
	}



}



class TimePlayerEnteredSessionWihtoutFrog {
	var session;
	var mvp_value;
	num timesCalled = 0;	var player = makeRenderingSnapshot;
	var doomedTimeClone;
	num importanceRating = 10;
	num timesCalled = 0;
	var secondTimeClone = null;  //second time clone undoes first undo

	//this is so illegal.
	


	TimePlayerEnteredSessionWihtoutFrog(this.session, this.mvp_value, this.player, this.doomedTimeClone) {}


	dynamic humanLabel(){
		String ret = "Make the " + this.player.htmlTitle() + " prototype a frog before entering the session. ";
		return ret;
	}
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.currentHP = this.doomedTimeClone.hp;

			if(this.secondTimeClone){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.currentHP = this.secondTimeClone.hp;
				return undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that their past-selves kernel sprite needs to be prototyped with this FROG. You do not even want to know how long it took them to get back to earth, and then time-travel to before the" +  player.htmlTitleBasic() + " entered the session. They are commited to this. ";
			narration += " No matter what 'fate' says.  They don't even care how illegal this is. ";
			narration +=  "The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes with in a cloud of gears to join the final battle.";
			div.append(narration);

			player.object_to_prototype = new GameEntity(null, "Frog",null);
			player.object_to_prototype.power = 20;
			player.object_to_prototype.illegal = true;
			player.object_to_prototype.mobility = 100;
			var divID = (div.attr("id")) + "_alt_jack_promotion";
			String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone);
			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			return false;  //let original scene happen as well.
	}

}



//you really shouldn't need to help with frog breeding more than twice.
dynamic removeFrogSpam(events){
	List<dynamic> eventsToRemove = []; //don't mod an array as you loop over it.
	num frogsSoFar = 0;
	 for(num i = 0; i<events.length; i++){
		 if(events[i].constructor.name == "FrogBreedingNeedsHelp"){
			 frogsSoFar ++;
			 if(frogsSoFar > 1){
				 eventsToRemove.push(events[i]);
			 }
		 }
	 }

	  for(num k = 0; k<eventsToRemove.length; k++){
		 removeFromArray(eventsToRemove[k], events);
	 }
	 return events;
}


//YellowYardcontroller knows what makes two events functionally equivalent
dynamic removeRepeatEvents(events){
	List<dynamic> eventsToRemove = []; //don't mod an array as you loop over it.
	 for(num i = 0; i<events.length; i++){
        var e1 = events[i];
		for(var j = i; j<events.length-i; j++){
		  var e2 = events[j];
		  //don't be literally teh same object, but do you match?
		   if(e1 != e2 && doEventsMatch(e1,e2)){
			 // print(e1.humanLabel() + " matches " + e2.humanLabel())
              eventsToRemove.push(e2);
			}
		}
     }

	 for(num k = 0; k<eventsToRemove.length; k++){
		 removeFromArray(eventsToRemove[k], events);
	 }
	 return events;
}


dynamic padEventsToNumWithKilling(events, session, doomedTimeClone, num){
	var num = num - events.length;
	num = Math.min(num, session.players.length);
	for(int i = 0; i<num; i++){
			events.push(new KillPlayer(session, session.players[i]))
	}
	return events;
}


void sortEventsByImportance(events){
	return events.sort(comparePriority);
}



function comparePriority(a,b) {
  return b.importanceRating - a.importanceRating;
}


dynamic listEvents(events){
	String ret = "";
	for(num i = 0; i<events.length; i++){
		ret += "\n" +events[i].humanLabel();
	}
	return ret;
}



class undoTimeUndoScene {

	undoTimeUndoScene(this.div, this.session, this.event, this.timeClone1, this.timeClone2) {}



//	print("times called : " + this.timesCalled);
	String narration = "<br>A doomed " + timeClone1.htmlTitleBasic() + " suddenly warps in from the future. ";
	narration +=  " But before they can do anything, a second doomed " +timeClone2.htmlTitleBasic()  + " warps in and grabs them.  Both vanish in a cloud of gears and clocks to join the final battle.";

	div.append(narration);

	var divID = (div.attr("id")) + "_alt_" + timeClone1.chatHandle;
	String canvasHTML = "<br><canvas id;='canvas" + divID+"' width='" +canvasWidth + "' height;="+canvasHeight + "'>  </canvas>";
	div.append(canvasHTML);
	var canvasDiv = querySelector("#canvas"+ divID);

	var pSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawTimeGears(pSpriteBuffer);
	drawSprite(pSpriteBuffer,timeClone1);

	var dSpriteBuffer = getBufferCanvas(querySelector("#sprite_template"));
	drawTimeGears(dSpriteBuffer);
	drawSpriteTurnways(dSpriteBuffer,timeClone2);


	copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
	copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);

	removeFromArray(event, session.yellowYardController.eventsToUndo);
	return false;
}
