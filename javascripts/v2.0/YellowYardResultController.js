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
var yyrEventsGlobalVar = [];

function YellowYardResultController(){
    this.eventsToUndo = [];

    this.doesEventNeedToBeUndone = function(e){
       console.log(e);
        for(var i = 0; i<this.eventsToUndo.length; i++){
          var e2 = this.eventsToUndo[i];
          if(doEventsMatch(e,e2)){
              return e2;
          }
        }
        return null;
    }




}

function doEventsMatch(event1, event2){
  if(event1.session.session_id != event2.session.session_id){
      console.log("session id did not match.")
      return false;
  }
  //are they the same kind of event
  if(event1.constructor.name != event2.constructor.name){
    console.log("constructor did not match.")
    return false;
  }
  if(event1.mvp_value != event2.mvp_value){
      console.log("mvp did not match")
      return false;
  }
  //should work even if player is supposed to be null
  if(event1.player.class_name != event2.player.class_name){
      console.log("player class did not match")
      return false;
  }

  if(event1.player.aspect != event2.player.aspect){
      console.log("player aspect did not match")
      return false;
  }

  return true;
}


function decision(){
  var a =$("input[name='decision']:checked").val()
  var eventDecided = yyrEventsGlobalVar[parseInt(a)];
  alert(eventDecided.humanLabel());
  curSessionGlobalVar.addEventToUndoAndReset(eventDecided);
}
