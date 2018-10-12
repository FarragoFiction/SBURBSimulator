import "dart:html";

import "../SBURBSim.dart";
export "BigBadEntered.dart";
export "CrownedCarapaceHappened.dart";
export "FrogBreedingNeedsHelp.dart";
export "PlayerDiedButCouldGodTier.dart";
export "DeadSessionPlayerEntered.dart";
export "PlayerEnteredSession.dart";
export "PlayerWentGrimDark.dart";
export "PlayerWentMurderMode.dart";
export "TimePlayerEnteredSessionwithoutFrog.dart";
export "PlayerDiedForever.dart";
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
    return events..sort(ImportantEvent.comparePriority); //cant remember if it shigh to low or low to high
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

  var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
  Drawing.drawTimeGears(pSpriteBuffer);
  Drawing.drawSprite(pSpriteBuffer,timeClone1);

  var dSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
  Drawing.drawTimeGears(dSpriteBuffer);
  Drawing.drawSpriteTurnways(dSpriteBuffer,timeClone2);


  Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
  Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0);

  removeFromArray(event, session.yellowYardController.eventsToUndo);
  return false;
  }

}




/*deprecated post npc update, its not just jack anymore
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

			var pSpriteBuffer = Drawing.getBufferCanvas(SimController.spriteTemplateWidth, SimController.spriteTemplateHeight);
			Drawing.drawSprite(pSpriteBuffer,this.doomedTimeClone);
			Drawing.drawTimeGears(canvasDiv);//, this.doomedTimeClone);
			Drawing.copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0);
			return true;
	}

}

*/







