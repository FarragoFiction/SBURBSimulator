import "dart:html";

import "../SBURBSim.dart";

 /*
	While the session contains a list of every ImportantEvent that happens inside of it,
	THIS object contains a list of every ImportantEvent the Observer has decided to change.

	it can also compare two important events to see if they are the same.

	TODO: ~~~~~~~~~~~~~~~~~ HAVE AB COMMENT ON SESSIONS THAT HAVE THIS AVAILABLE. " Shit. That went south fast. I better tell JR."

	When I described this to a friend they said "aren't you worried this will turn into a bucket of spiders?".
	(.i.e become intractably complicated and impossible to debug)
	My response: "This has always been a bucket of spidres, I just decided to dump the whole thing on my head and do a little dance with it."

	This is such a stupid idea. So many things can go wrong.  But it's so irresistable. I NEED to make ridiculous ground hog day time shenanigans possible. It is my destiny.

	hrmm...if time playered triggered, maybe can add evil actions, like Damara was doing.
	dirupt ectobiology. kill players, etc. could trigger some godtiers
*/
List<ImportantEvent> yyrEventsGlobalVar = [];

class YellowYardResultController {
 List<ImportantEvent> eventsToUndo = [];


	YellowYardResultController() {}


	ImportantEvent doesEventNeedToBeUndone(ImportantEvent e){
    //  //print("Does: " + e.humanLabel() + " need to be undone?")
        for(num i = 0; i<this.eventsToUndo.length; i++){
            ImportantEvent e2 = this.eventsToUndo[i];
		 // //print("checking if needs to be undone");
          if(doEventsMatch(e,e2,true)){
          //  //print("retunning event that will provide alternate scene, " + e2.humanLabel())
              return e2;
          }
        }
        return null;
    }


}


/*
	This is not perfecct.  A player can, for example, die multiple times with the same mvp power level.
	But i figure if multiple mind-influenced time players warp into save them multiple times (even from one decision), well...time shenanigans.
	it is not unreasonable to imagien 2 timelines that are extremely similar where the Observer made the same choice.
*/
bool doEventsMatch(ImportantEvent newEvent, ImportantEvent storedEvent, [bool spawn = false]){
	////print("comparing: '" + newEvent.humanLabel() + "' to '" + storedEvent.humanLabel() + "'")
	if(newEvent == null || storedEvent == null) return false; //can't match if one of them doesn't exist.;
  if(newEvent.session.session_id != storedEvent.session.session_id){
    //  //print("session id did not match.");
      return false;
  }
  //are they the same kind of event
  if(newEvent.runtimeType != storedEvent.runtimeType){
  //  //print("constructor did not match.");
    return false;
  }
  if(newEvent.mvp_value != storedEvent.mvp_value ){ //mind field means mvp doesn't matter.
      return false;
    //  //print("mvp did not match");
  }
  if(newEvent.player != null && storedEvent.player != null){
	  //should work even if player is supposed to be null
	  if(newEvent.player.class_name != storedEvent.player.class_name){
		 ////print("player class did not match");
		  return false;
	  }

	    if(newEvent.player.aspect != storedEvent.player.aspect){
    //  //print("player aspect did not match");
		return false;
		}
    //print("yes, there is a match.");
    if(spawn){ //don't spawn a time cloen if i'm checking for afterlife stuff.
      spawnDoomedTimeClone(newEvent, storedEvent);
    }
    return true;
  }
  if(spawn){ //don't spawn a time cloen if i'm checking for afterlife stuff.
    spawnDoomedTimeClone(newEvent, storedEvent);
  }
  return true;
}



void spawnDoomedTimeClone(ImportantEvent newEvent, ImportantEvent storedEvent){
    //print("spawning a doomed time clone");
    //since i know the events match, make sure my player is up to date with the current session.
    //had a stupidly tragic bug where I was bringing players back in the DEAD SESSION instead of this new version of it.
    storedEvent.player = newEvent.player;
    storedEvent.session = newEvent.session; //cant get space players otherwise
    //trigger the new sessions timePlayer.  time shenanigans wear on sanaity.
    var alphaTimePlayer = findAspectPlayer(newEvent.session.players, Aspects.TIME);
    alphaTimePlayer.addStat(Stats.SANITY, -10); //how many re-dos does this give me before they snap?
    alphaTimePlayer.doomedTimeClones.add(storedEvent.doomedTimeClone);
    alphaTimePlayer.flipOut("their own doomed time clones that seem to be mind controlled or something");
    if(storedEvent.secondTimeClone != null){
        //print("think there is a second time clone");
        alphaTimePlayer.doomedTimeClones.add(storedEvent.secondTimeClone);
    }
}




void decision(){
  String a = (querySelector("input[name='decision']:checked") as InputElement).value;
  int index = int.parse(a, onError:(String s) => 0);
  if(index < yyrEventsGlobalVar.length){
    var eventDecided = yyrEventsGlobalVar[int.parse(a, onError:(String s) => 0)];
    //alert(eventDecided.humanLabel());
    curSessionGlobalVar.addEventToUndoAndReset(eventDecided);
  }else{
    //undoing undoing an event.
    index = index - yyrEventsGlobalVar.length;
    var eventToUndo2x = curSessionGlobalVar.yellowYardController.eventsToUndo[index];
    var timePlayer = findAspectPlayer(curSessionGlobalVar.players, Aspects.TIME);
    var doom = Player.makeRenderingSnapshot(timePlayer);
		doom.dead = false;
		doom.doomed = true;
		doom.setStat(Stats.CURRENT_HEALTH, doom.getStat(Stats.HEALTH));
    doom.influenceSymbol = "mind_forehead.png";
    eventToUndo2x.secondTimeClone = doom;
    curSessionGlobalVar.addEventToUndoAndReset(null);
  }

}
