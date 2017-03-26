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

//screw fate, we have a time player here, and obviously this fate leads to a doomed timeline anyways and thus is changeable.
//have alternate timeline change based on it being a dreamself that's dying versus an unsmooched regular self.
//if i ever implmeent moon destruction, will need to refactor this, unless want to have time shenanigans. (god tier time players can take dying player to before moon was destroyed???)
function PlayerDiedButCouldGodTier(session, mvp_value, player){
	this.session = session;
	this.importanceRating = 9;
	this.mvp_value = mvp_value;
	this.player = player;

	this.humanLabel = function(){
		var ret  = "";
		ret += "Have the " + this.player.htmlTitleBasic() + " go God Tier instead of dying forever. " + this.mvp_value ;
		return ret;
	}
}


function PlayerDiedForever(session, mvp_value, player){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 5;
	this.player = player;

	this.humanLabel = function(){
		var ret  = "Make the " + this.player.htmlTitleBasic() + " not permanently dead.";
		return ret;
	}
}

function PlayerWentGrimDark(session, mvp_value,player){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 7;
	this.player = player;

	this.humanLabel = function(){
		var ret  = "Prevent the " + this.player.htmlTitleBasic() + " from going Grimdark."
		return ret;
	}
}

function PlayerWentMurderMode(session, mvp_value, player){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 7;
	this.player = player;

	this.humanLabel = function(){
		var ret  = "Prevent the " + this.player.htmlTitleBasic() + " from going into Murder Mode.";
		return ret;
	}
}

//grab ring before this can happen.
function JackPromoted(session, mvp_value){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 10;

	this.humanLabel = function(){
		var ret  = "Prevent Jack from obtaining the Black Queen's RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD.";
		return ret;
	}
}

//if knight, directly help, if not but knight alive, force them to help. else, indirect help
//if knight of space (most common reason this is called, indirect help)
function FrogBreedingNeedsHelp(session, mvp_value){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 2;  //really, this is probably the least useful thing you could do. If this is the ONLY thing that went wrong, your session is going great.
	var spacePlayer = findAspectPlayer(this.session.players, "Space");
	this.humanLabel = function(){
		var ret  = "Help the " + spacePlayer.htmlTitleBasic() + " complete frog breeding duties.";
		return ret;
	}

}

//not an important event that gets recorded, but something a time player can go back in time to do.
function KillPlayer(session, player){
	this.session = session;
	this.player = player;
	this.importanceRating = 1;  //really, this is probably the least useful thing you could do. If this is the ONLY thing that went wrong, your session is going great.
	this.humanLabel = function(){
		var ret  = "Kill the " + player.htmlTitleBasic() + ".";
		return ret;
	}
}

function padEventsTo12WithKilling(events,session){
	var num = 12 - events.length;
	num = Math.min(num, session.players.length);
	for(var i = 0; i<num; i++){
			events.push(new KillPlayer(session, session.players[i]))
	}
	return events;
}
function sortEventsByImportance(events){
	return events.sort(comparePriority)
}

function comparePriority(a,b) {
  return b.importanceRating - a.importanceRating;
}

function listEvents(events){
	var ret = "";
	for(var i = 0; i<events.length; i++){
		ret += "\n" +events[i].humanLabel();
	}
	return ret;
}
