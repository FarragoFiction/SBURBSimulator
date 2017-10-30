import "dart:html";

import "../SBURBSim.dart";
/*
	Each of these important events have:
	a session
	a player (optional, whoever died, or went murder mode, or whatever)
	a mvp value (at time of event creation) keeps the important event referenceing the right timeline
	a importanceRating
	a alternateTimeline function.
	a humanLabel function.  instead of PlayerDiedButCouldGodTier it would be "The Heir of Life died with a living dream self. Make them GodTier."
*/
abstract class ImportantEvent { //TODO consider making this non abstract and have it have static methods? or can abstract clases have static methods?
  Session session;
  Player player;
  num mvp_value; //could be a float?
  int importanceRating = 1; //am I even still using this?
  Player doomedTimeClone; //TODO or should it be a playerSnapShot?
  num timesCalled=0; //what was this for again?
  Player secondTimeClone; //used to undo this event
  ImportantEvent(this.session, this.mvp_value, this.player, [this.doomedTimeClone = null]);
  String humanLabel();
  bool alternateScene(Element div);

  //TODO maybe these shouldn't live here, but dragging them out of global namespace for now.
  //reference with ImportantEvent.methodname.   It's fucking nice to have static again.
  //this'll really change up rleationships.

//you really shouldn't need to help with frog breeding more than twice.
  static dynamic removeFrogSpam(events){
    List<dynamic> eventsToRemove = []; //don't mod an array as you loop over it.
    num frogsSoFar = 0;
    for(num i = 0; i<events.length; i++){
      if(events[i] is FrogBreedingNeedsHelp){
        frogsSoFar ++;
        if(frogsSoFar > 1){
          eventsToRemove.add(events[i]);
        }
      }
    }

    for(num k = 0; k<eventsToRemove.length; k++){
      removeFromArray(eventsToRemove[k], events);
    }
    return events;
  }


//YellowYardcontroller knows what makes two events functionally equivalent
  static List<ImportantEvent> removeRepeatEvents(List<ImportantEvent> events){
    List<ImportantEvent> eventsToRemove = []; //don't mod an array as you loop over it.
    for(num i = 0; i<events.length; i++){
      var e1 = events[i];
      for(var j = i; j<events.length-i; j++){
        var e2 = events[j];
        //don't be literally teh same object, but do you match?
        if(e1 != e2 && doEventsMatch(e1,e2)){ // TODO was this kept in YellowYardController?
          // //print(e1.humanLabel() + " matches " + e2.humanLabel())
          eventsToRemove.add(e2);
        }
      }
    }

    for(num k = 0; k<eventsToRemove.length; k++){
      removeFromArray(eventsToRemove[k], events);
    }
    return events;
  }


  static List<ImportantEvent> sortEventsByImportance(List<ImportantEvent> events){
    return events..sort(ImportantEvent.comparePriority); //TODO how do you do sorting in Dart?
  }



  static int comparePriority(ImportantEvent a, ImportantEvent b) {
    return b.importanceRating - a.importanceRating;
  }


  static String listEvents(events){
    String ret = "";
    for(num i = 0; i<events.length; i++){
      ret += "\n" +events[i].humanLabel();
    }
    return ret;
  }


//why was this a class???
  static bool undoTimeUndoScene(Element div, Session session, ImportantEvent event, Player timeClone1, Player timeClone2)  {

//	//print("times called : " + this.timesCalled);
  String narration = "<br>A doomed " + timeClone1.htmlTitleBasic() + " suddenly warps in from the future. ";
  narration +=  " But before they can do anything, a second doomed " +timeClone2.htmlTitleBasic()  + " warps in and grabs them.  Both vanish in a cloud of gears and clocks to join the final battle.";

  appendHtml(div, narration);

  var divID = (div.id) + "_alt_${timeClone1.id}";
  String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
  appendHtml(div, canvasHTML);
  var canvasDiv = querySelector("#canvas"+ divID);

  var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
  Drawing.drawTimeGears(pSpriteBuffer);
  Drawing.drawSprite(pSpriteBuffer,timeClone1);

  var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
  Drawing.drawTimeGears(dSpriteBuffer);
  Drawing.drawSpriteTurnways(dSpriteBuffer,timeClone2);


  Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
  Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);

  removeFromArray(event, session.yellowYardController.eventsToUndo);
  return false;
  }

}



//TODO, maybe allow them to prevent existing god tiers?

//screw fate, we have a time player here, and obviously this fate leads to a doomed timeline anyways and thus is changeable.
//have alternate timeline change based on it being a dreamself that's dying versus an unsmooched regular self.
//if i ever implmeent moon destruction, will need to refactor this, unless want to have time shenanigans. (god tier time players can take dying player to before moon was destroyed???)
class PlayerDiedButCouldGodTier extends ImportantEvent{

	PlayerDiedButCouldGodTier(Session session, num mvp_value, Player player, [Player doomedTimeClone = null]): super(session, mvp_value, player, doomedTimeClone);

  @override
	String humanLabel(){
		String ret = "";
		ret += "Have the " + this.player.htmlTitleBasicNoTip() + " go God Tier instead of dying forever. ";
		return ret;
	}
  @override
	bool alternateScene(div){
			timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));


			if(secondTimeClone != null){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
				return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			////print("times called : " + this.timesCalled);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + this.player.htmlTitleBasic() + " needs to go God Tier now. ";
			narration += " No matter what 'fate' says. ";
			narration += " They scoop the corpse up and vanish with it in a cloud of gears, depositing it instantly on the " + this.player.htmlTitleBasic() + "'s ";
			if(this.player.isDreamSelf == true){
				narration += "sacrificial slab, where it glows and ascends to the God Tiers with a sweet new outfit";
			}else{
				narration += " quest bed. The corpse glows and rises Skaiaward. ";
				narration +="On ${this.player.moon}, their dream self takes over and gets a sweet new outfit to boot.  ";
			}
			narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
			appendHtml(div, narration);

			var divID = (div.id) + "_alt_${this.player.id}";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSprite(dSpriteBuffer,this.player);
			Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);

			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			player.makeGodTier();

			var divID2 = (div.id) + "_alt_god${player.id}";
			String canvasHTML2 = "<br><canvas id='canvas" + divID2+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML2);
			var canvasDiv2 = querySelector("#canvas"+ divID2);
			List<dynamic> players = [];
			players.add(player);
			Drawing.drawGetTiger(canvasDiv2, players);//,repeatTime);
			return true;
	}

}




class PlayerDiedForever  extends ImportantEvent {
	int importanceRating = 5;

	PlayerDiedForever(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

  @override
	String humanLabel(){
		String ret = "Make the " + this.player.htmlTitleBasicNoTip() + " not permanently dead.";
		if(session.mutator.mindField) ret = "Make the " + this.player.htmlTitleBasicNoTip() + " NEVER permanently dead, lol.";
		return ret;
	}
  @override
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));
			if(secondTimeClone != null) this.secondTimeClone.dead = false;
			if(secondTimeClone != null) this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
			if(secondTimeClone != null){
				return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " +player.htmlTitleBasic() + " needs to be protected. ";
			narration += " No matter what 'fate' says. ";
			narration += " They sacrifice their life for the " + player.htmlTitleBasic() + ". ";


			appendHtml(div, narration);

			player.makeAlive();
			player.addStat(Stats.SANITY, -0.5);

			this.doomedTimeClone.makeDead("sacrificing themselves through a YellowYard");

			var divID = (div.id) + "_alt_${player.id}";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSpriteTurnways(dSpriteBuffer,player);
			Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);

			var alphaTimePlayer = findAspectPlayer(this.session.players, Aspects.TIME);
			removeFromArray(this.doomedTimeClone, alphaTimePlayer.doomedTimeClones);   //DEAD
			this.session.afterLife.addGhost(this.doomedTimeClone);
			return true;
	}

}



class PlayerWentGrimDark  extends ImportantEvent {
	int importanceRating = 7;

	PlayerWentGrimDark(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone)
	{
		this.player = Player.makeRenderingSnapshot(player);	// TODO: Discover why this is needed (it wasn't working anyway) -PL
	}

  @override
	String humanLabel(){
		String ret = "Prevent the " + this.player.htmlTitleBasicNoTip() + " from going Grimdark.";
		if(session.mutator.mindField) ret = "Prevent the " + this.player.htmlTitleBasicNoTip() + " from EVER going Grimdark.";

		return ret;
	}
  @override
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

			if(secondTimeClone != null){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
				return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
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
			appendHtml(div, narration);
			player.addStat(Stats.SANITY, -10);


			var divID = (div.id) + "_alt_${player.id}";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSpriteTurnways(dSpriteBuffer,player);

			Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
			return true;
	}

}



class PlayerWentMurderMode  extends ImportantEvent{
	int importanceRating = 7;

	PlayerWentMurderMode(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

  @override
	String humanLabel(){
		String ret = "Prevent the " + this.player.htmlTitleBasicNoTip() + " from going into Murder Mode.";
		if(session.mutator.mindField) ret = "Prevent the " + this.player.htmlTitleBasicNoTip() + " from EVER going into MurderMode.";
		return ret;
	}
  @override
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

			if(secondTimeClone != null){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
				return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
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
			appendHtml(div, narration);
			player.addStat(Stats.SANITY, -10);


			var divID = (div.id) + "_alt_${player.id}";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSpriteTurnways(dSpriteBuffer,player);

			Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
			return true;
	}

}



//grab ring before this can happen.
class JackPromoted  extends ImportantEvent{
	int importanceRating = 10;

	JackPromoted(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

  @override
	String humanLabel(){
		String ret = "Prevent Jack from obtaining the Black Queen's RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD.";
		if(session.mutator.mindField) ret = "Prevent Jack from obtaining the Black Queen's RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD.";
		return ret;
	}
  @override
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

			if(secondTimeClone != null){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
				return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the Black Queen's RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD needs to be destroyed. Immediately.";
			narration += " No matter what 'fate' says. Jack Noir immediately begins flipping out, but the RING is stolen before he can do anything. ";
			narration +=  "The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes with the RING in a cloud of gears to join the final battle.";
			appendHtml(div, narration);
			this.session.destroyBlackRing();

			var divID = (div.id) + "_alt_jack_promotion";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);
			Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			return true;
	}

}



//if knight, directly help, if not but knight alive, force them to help. else, indirect help
//if knight of space (most common reason this is called, indirect help)
//TODO important, time player isn't being passed in this contstructor for some reason.
//was i derping?
class FrogBreedingNeedsHelp extends ImportantEvent {
	int importanceRating = 2;  //really, this is probably the least useful thing you could do. If this is the ONLY thing that went wrong, your session is going great.
	FrogBreedingNeedsHelp(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

  @override
	String humanLabel(){
		var spacePlayer = findAspectPlayer(this.session.players, Aspects.SPACE);
		String ret = "Help the " + spacePlayer.htmlTitleBasicNoTip() + " complete frog breeding duties.";
		return ret;
	}
  @override
	bool alternateScene(div){
			var spacePlayer = findAspectPlayer(this.session.players, Aspects.SPACE);
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

			if(secondTimeClone != null){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
				return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + spacePlayer.htmlTitleBasic() + " needs to be helped with their Frog Breeding duties. ";
			narration += " No matter what anybody says about time travel frog breeding being an overly elaborate and dangerous undertaking.  Desperate times, Desperate measures. ";
			if(this.doomedTimeClone.class_name == SBURBClassManager.KNIGHT){
				narration += " Luckily they were SUPPOSED to be helping breed the frog in the first place, so it's just a matter of making enough stable time loops to make a huge dent in the process. ";
				spacePlayer.increaseLandLevel(10.0);
			}else{
				narration += " Unfortunately they are not a Knight, and thus are banned from helping breed frogs directly.  But with a little creativity and a LOT of stable time loops they manage to indirectly help a huge amount. ";
				spacePlayer.increaseLandLevel(8.0);
			}
			narration +=  " The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
			appendHtml(div, narration);

			var divID = (div.id) + "_alt_${spacePlayer.id}";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSpriteTurnways(dSpriteBuffer,spacePlayer);

			Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
			////print("done helping frog a scene, seed is at: " + Math.seed);
			return true;
	}


}




class PlayerEnteredSession  extends ImportantEvent {
	int importanceRating = 5;
	PlayerEnteredSession(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

  @override
	String humanLabel(){
		String ret = "Kill the " + this.player.htmlTitleBasicNoTip() + " before they enter the session.";
		if(session.mutator.mindField) ret = "Kill the " + this.player.htmlTitleBasicNoTip() + " as much as you can. Fuck that guy!";
		return ret;
	}
  @override
	bool alternateScene(div){
		this.timesCalled ++;
		this.doomedTimeClone.dead = false;
		this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

			if(secondTimeClone != null){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
				return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + player.htmlTitleBasic() + " needs to die.  You do not even want to know how long it took them to get back to earth, and then time-travel to before the" +  player.htmlTitleBasic() + " entered the session. They are commited to this. ";
			narration += " No matter what 'fate' says. ";

			narration +=  "After a brief struggle, the doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes in a cloud of gears to join the final battle.";
			player.dead = true;
			narration += player.makeDead("apparantly displeasing the Observer.");
			appendHtml(div, narration);

			this.doomedTimeClone.victimBlood = player.bloodColor;


			var divID = (div.id) + "_alt_${player.id}";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
		Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);

			var dSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
		Drawing.drawSprite(dSpriteBuffer,player);

		Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
		Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);
			return false; //let the original scene happen as well.
	}



}


//...huh...how did I not notice this typo soner.
//TODO when refactor is done and everything is hooked up, test out intellij-s auto refactor rename variable thing
class TimePlayerEnteredSessionWihtoutFrog  extends ImportantEvent {
	int importanceRating = 10;
	//this is so illegal.
	TimePlayerEnteredSessionWihtoutFrog(Session session, num mvp_value, Player player, Player doomedTimeClone): super(session, mvp_value, player, doomedTimeClone);

  @override
	String humanLabel(){
		String ret = "Make the " + this.player.htmlTitleBasicNoTip() + " prototype a frog before entering the session. ";
		return ret;
	}
  @override
	bool alternateScene(div){
			this.timesCalled ++;
			this.doomedTimeClone.dead = false;
			this.doomedTimeClone.setStat(Stats.CURRENT_HEALTH, this.doomedTimeClone.getStat(Stats.HEALTH));

			if(secondTimeClone != null){
				this.secondTimeClone.dead = false;
				this.secondTimeClone.setStat(Stats.CURRENT_HEALTH, this.secondTimeClone.getStat(Stats.HEALTH));
				return ImportantEvent.undoTimeUndoScene(div, this.session, this, this.doomedTimeClone, this.secondTimeClone);
			}
			var player = this.session.getVersionOfPlayerFromThisSession(this.player);
			String narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that their past-selves kernel sprite needs to be prototyped with this FROG. You do not even want to know how long it took them to get back to earth, and then time-travel to before the" +  player.htmlTitleBasic() + " entered the session. They are commited to this. ";
			narration += " No matter what 'fate' says.  They don't even care how illegal this is. ";
			narration +=  "The doomed " + this.doomedTimeClone.htmlTitleBasic() + " vanishes with in a cloud of gears to join the final battle.";
			appendHtml(div, narration);

			player.object_to_prototype = new GameEntity("Frog", doomedTimeClone.session); //new GameEntity("Frog",0,null);
			player.object_to_prototype.setStat(Stats.POWER,20);
			player.object_to_prototype.illegal = true;
			player.object_to_prototype.setStat(Stats.MOBILITY, 100);
			var divID = (div.id) + "_alt_jack_promotion";
			String canvasHTML = "<br><canvas id='canvas" + divID+"' width='$canvasWidth' height='$canvasHeight'>  </canvas>";
			appendHtml(div, canvasHTML);
			var canvasDiv = querySelector("#canvas"+ divID);

			var pSpriteBuffer = Drawing.getBufferCanvas(querySelector("#sprite_template"));
			Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);
			Drawing.drawTimeGears(canvasDiv);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			return false;  //let original scene happen as well.
	}

}

