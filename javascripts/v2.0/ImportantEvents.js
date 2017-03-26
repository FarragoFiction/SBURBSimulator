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
function PlayerDiedButCouldGodTier(session, mvp_value, player, doomedTimeClone){
	this.session = session;
	this.importanceRating = 9;
	this.mvp_value = mvp_value;
	this.player = player;
	this.doomedTimeClone = doomedTimeClone;
	this.timesCalled = 0;

	this.humanLabel = function(){
		var ret  = "";
		ret += "Have the " + this.player.htmlTitleBasic() + " go God Tier instead of dying forever. " + this.mvp_value ;
		return ret;
	}

	this.alternateScene = function(div){
			this.timesCalled ++;
			console.log("times called: " + this.timesCalled)
			console.log("TODO: implement alternate scene. godtier player.")
			var narration = "<br>A " + this.doomedTimeClone.htmlTitleBasic() + " suddenly warps in from the future. ";
			narration +=  " They come with a dire warning of a doomed timeline. ";
			narration += " Something seems...off...about them. But they are adamant that the " + this.player.htmlTitleBasic() + " needs to go GodTier now. "
			narration += " No matter what 'fate' says. "
			narration += " They scoop the corpse up and vanish with it in a cloud of gears, depositing it instantly on the " + this.player.htmlTitleBasic() + "'s ";
			if(this.player.isDreamSelf == true){
				narration += "sacrificial slab, where it glows and ascends to the God Tiers with a sweet new outfit";
			}else{
				narration += " quest bed. The corpse glows and rises Skaiaward. ";
				narration +="On " + this.player.moon + ", their dream self takes over and gets a sweet new outfit to boot.  ";
			}
			div.append(narration);

			var divID = (div.attr("id")) + "_alt_" + this.player.chatHandle;
			var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvasDiv = document.getElementById("canvas"+ divID);

			var pSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
			drawSprite(pSpriteBuffer,this.doomedTimeClone)

			var dSpriteBuffer = getBufferCanvas(document.getElementById("sprite_template"));
			drawSprite(dSpriteBuffer,this.player)
			drawTimeGears(canvasDiv, this.doomedTimeClone);
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, pSpriteBuffer,-100,0)
			copyTmpCanvasToRealCanvasAtPos(canvasDiv, dSpriteBuffer,100,0)

			this.player.godTier = true;
			this.player.dreamSelf = false;
			this.player.murderMode = false;
			this.player.grimDark = false;
			this.player.leftMurderMode = false; //no scars
			this.player.triggerLevel = 1;
			this.player.dead = false;
			this.player.power += 200;
			this.player.canGodTierRevive = true;
			this.player.victimBlood = null;

			var divID2 = (div.attr("id")) + "_alt_god" + this.player.chatHandle;
			var canvasHTML2 = "<br><canvas id='canvas" + divID2+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML2);
			var canvasDiv2 = document.getElementById("canvas"+ divID2);
			var players = [];
			players.push(this.player)
			drawGetTiger(canvasDiv2, players,repeatTime)
			alert("alt scene, TODO add doomed time clone to special list of set time clones to add to final fight. or make normal list array of snapshots. whatever.  Current Bug; why is this happening multuiple times. why is my clone ALSO have mind symbol over them?");

	}
}


function PlayerDiedForever(session, mvp_value, player, doomedTimeClone){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 5;
	this.player = player;
	this.doomedTimeClone = doomedTimeClone;

	this.humanLabel = function(){
		var ret  = "Make the " + this.player.htmlTitleBasic() + " not permanently dead.";
		return ret;
	}

	this.alternateScene = function(div){
			console.log("TODO: implement alternate scene. dead player.")
	}
}

function PlayerWentGrimDark(session, mvp_value,player, doomedTimeClone){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 7;
	this.player = player;
	this.doomedTimeClone = doomedTimeClone;

	this.humanLabel = function(){
		var ret  = "Prevent the " + this.player.htmlTitleBasic() + " from going Grimdark."
		return ret;
	}

	//just realized, this isn't just a replacement for god tiering. god tiering uses a corpse.
	//this needs to be called not at a failed revival, but at the creation of the coprse.
	//jack rampage, murder mode, fight king/queen?
	//163251  22577  59610
	this.alternateScene = function(div){
			console.log("TODO: implement alternate scene. grim dark")
	}
}

function PlayerWentMurderMode(session, mvp_value, player, doomedTimeClone){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 7;
	this.player = player;
	this.doomedTimeClone = doomedTimeClone;

	this.humanLabel = function(){
		var ret  = "Prevent the " + this.player.htmlTitleBasic() + " from going into Murder Mode.";
		return ret;
	}

	this.alternateScene = function(div){
			console.log("TODO: implement alternate scene. prevent murder mode")
	}
}

//grab ring before this can happen.
function JackPromoted(session, mvp_value, doomedTimeClone){
	this.session = session;
	this.mvp_value = mvp_value;
	this.importanceRating = 10;
	this.doomedTimeClone = doomedTimeClone;

	this.humanLabel = function(){
		var ret  = "Prevent Jack from obtaining the Black Queen's RING OF ORBS " +this.session.convertPlayerNumberToWords() + "FOLD.";
		return ret;
	}
	this.alternateScene = function(div){
			console.log("TODO: implement alternate scene. jack promoted.")
	}
}

//if knight, directly help, if not but knight alive, force them to help. else, indirect help
//if knight of space (most common reason this is called, indirect help)
function FrogBreedingNeedsHelp(session, mvp_value, doomedTimeClone){
	this.session = session;
	this.mvp_value = mvp_value;
	this.doomedTimeClone = doomedTimeClone;
	this.importanceRating = 2;  //really, this is probably the least useful thing you could do. If this is the ONLY thing that went wrong, your session is going great.
	var spacePlayer = findAspectPlayer(this.session.players, "Space");
	this.humanLabel = function(){
		var ret  = "Help the " + spacePlayer.htmlTitleBasic() + " complete frog breeding duties.";
		return ret;
	}
	this.alternateScene = function(div){
			console.log("TODO: implement alternate scene. breed frogs.")
	}

}

//not an important event that gets recorded, but something a time player can go back in time to do.
function KillPlayer(session, player, doomedTimeClone){
	this.session = session;
	this.player = player;
	this.doomedTimeClone = doomedTimeClone;
	this.importanceRating = 1;  //really, this is probably the least useful thing you could do. If this is the ONLY thing that went wrong, your session is going great.
	this.humanLabel = function(){
		var ret  = "Kill the " + player.htmlTitleBasic() + ".";
		return ret;
	}
	this.alternateScene = function(div){
			console.log("TODO: implement alternate scene. kill player.")
	}
}

function padEventsTo12WithKilling(events,session, doomedTimeClone){
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
