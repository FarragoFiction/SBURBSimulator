function Intro(session){
	this.canRepeat = false;
	this.session=session;
	this.playerList = [];  //whatthis.session.players are already in the medium when i trigger?
	this.player = null;
	this.trigger = function(playerList, player){
		this.playerList = playerList;
		this.player = player;
		return true; //this should never be in the main array. call manually.
	}

	this.corruptedLand = function(){
		if(corruptedOtherLandTitles.indexOf(this.player.land1) != -1 || corruptedOtherLandTitles.indexOf(this.player.land2) != -1 ){
			this.player.corruptionLevelOther = 100;
			console.log("corrupted land" + this.session.session_id)
			return "There is ...something very, very wrong about the " + this.player.land +". ";
		}
		return "";
	}

	this.corruptedSprite = function(){
		if(this.player.sprite.corrupted ){
			return "There is ...something very, very wrong about the " + this.player.sprite.htmlTitle();
		}
		return "";
	}

	this.changeBoggle = function(){
			if(this.player.aspect == "Blood"){
				return " They boggle vacantly at the " + this.player.land + ". ";
			}else if(this.player.aspect == "Mind"){
				return " They ogle at the " + this.player.land + ". ";
			}else if(this.player.aspect == "Rage"){
				return " They glare with bafflement at the " + this.player.land + ". ";
			}else if(this.player.aspect == "Time"){
				return " They are very confused by the " + this.player.land + ". ";
			}else if(this.player.aspect == "Void"){
				return " They stare blankly at the " + this.player.land + ". ";
			}else if(this.player.aspect == "Heart"){
				return " They run around excitedly in the " + this.player.land + ". ";
			}else if(this.player.aspect == "Breath"){
				return " They grin excitedly at the " + this.player.land + ". ";
			}else if(this.player.aspect == "Light"){
				return " They stare at the " + this.player.land + " with unrestrained curiosity. ";
			}else if(this.player.aspect == "Space"){
				return " They do not even understand the " + this.player.land + ". ";
			}else if(this.player.aspect == "Hope"){
				return " They are enthused about the " + this.player.land + ". ";
			}else if(this.player.aspect == "Life"){
				return " They are obviously pleased with " + this.player.land + ". ";
			}else if(this.player.aspect == "Doom"){
				return " They stare with trepidation at the " + this.player.land + ". ";
			}
	}

//not a yellow yard thing, just random
	this.changePrototyping = function(div){
		if(this.player.object_to_prototype.power > 200 && Math.seededRandom() > .8){
			var divID = (div.attr("id"))
			var canvasHTML = "<br><canvas id='canvaskernel" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
			div.append(canvasHTML);
			var canvas = document.getElementById("canvaskernel"+ divID);
			var times = findAllAspectPlayers(this.session.players, "Time"); //they don't have to be in the medium, though
			var timePlayer = getRandomElementFromArray(times); //ironically will probably allow more timeless sessions without crashes.
			drawTimeGears(canvas, timePlayer);
			drawSinglePlayer(canvas, timePlayer);
			var ret = "A " + timePlayer.htmlTitleBasic() + " suddenly warps in from the future. ";
			if(timePlayer.dead){
				ret += "It's a little alarming how much they are bleeding. "
			}
			ret += " They come with a dire warning of a doomed timeline. ";
			ret += "They dropkick the " + this.player.object_to_prototype.htmlTitle() + " out of the way and jump into the " + this.player.htmlTitleBasic() + "'s kernel sprite instead. <br> "
			this.player.object_to_prototype = copyGameEntity(timePlayer, timePlayer.chatHandle)
			this.player.object_to_prototype.helpfulness = 1;
			//shout out to DinceJof for the great sprite phrase
			this.player.object_to_prototype.helpPhrase = " used to be a Player like you, until they took a splinter to the timeline, so they know how all this shit works. Super helpful.";
			this.player.object_to_prototype.player = true;
			console.log("time player sprite in session: " + this.session.session_id);

		}else if((this.player.dead == true || this.player.isDreamSelf == true || this.player.dreamSelf == false) && Math.seededRandom() > .1){ //if tier 2 is ever a thing, make this 50% instead and have spries very attracted to extra corpes later on as well if they aren't already players or...what would even HAPPEN if you prototyped yourself twice....???
			var ret = "Through outrageous shenanigans, one of the " + this.player.htmlTitle() + "'s superfluous corpses ends up prototyped into their kernel sprite. <br>";
			this.player.object_to_prototype =copyGameEntity(this.player, this.player.chatHandle) //no, don't say 'corpsesprite'
			console.log("player sprite in session: " + this.session.session_id);
			this.player.object_to_prototype.helpfulness = 1;
			this.player.object_to_prototype.helpPhrase = " is interested in trying to figure out how to play the game, since but for shenanigans they would be playing it themselves.";
			this.player.object_to_prototype.player = true;

		}
		div.append(ret);
		return "";
	}

	this.addImportantEvent = function(){
		var current_mvp =  findStrongestPlayer(this.session.players)
		//console.log("Entering session, mvp is: " + current_mvp.power)
		if(this.player.aspect == "Time" && !this.player.object_to_prototype.illegal){
			return this.session.addImportantEvent(new TimePlayerEnteredSessionWihtoutFrog(this.session, current_mvp.power,this.player) );
		}else{
			return this.session.addImportantEvent(new PlayerEnteredSession(this.session, current_mvp.power,this.player) );
		}

	}

	this.grimPlayer2Chat = function( player1, player2){
			var r1 = player1.getRelationshipWith(player2);
			var player1Start = player1.chatHandleShort()+ ": "
			var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
			var chatText = "";
			if(r1.type() == r1.goodBig){
				chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm in the medium!");
			}else{
				chatText += chatLine(player1Start, player1,"Hey, I'm in the medium!");
			}

			chatText += chatLine(player2Start, player2,"I don't care.");
			chatText += chatLine(player1Start, player1,"Whoa, uh. Are you okay?");
			chatText += chatLine(player2Start, player2,"I don't care.");
			chatText += chatLine(player1Start, player1,"Um...");
			chatText += chatLine(player2Start, player2,"Fine. Tell me about your Land.");
			chatText += chatLine(player1Start, player1,"Oh. Um. It's the " + player1.land +".");
			chatText += chatLine(player2Start, player2,"And your kernel?");
			chatText += chatLine(player1Start, player1,"A " + player1.object_to_prototype.htmlTitle() +".\n");
			chatText += chatLine(player2Start, player2,"Social obligation complete. Goodbye.");
			return chatText;
	}

	this.lightChat = function(player1,player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		if(r1.type() == r1.goodBig){
			chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm in the medium!");
		}else{
			chatText += chatLine(player1Start, player1,"Hey, I'm in the medium!");
		}

		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It appears to be the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"I guess it has something to do with my title? I am apparently the ' " + player1.titleBasic() + "'. ");
		chatText +=chatLine(player2Start, player2,"Whatever THAT means. ");
		chatText += chatLine(player1Start, player1,"Yes. Also, I prototyped my kernelsprite with a " + player1.object_to_prototype.htmlTitle() +".\n");
		if(player1.object_to_prototype.player){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that...");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");
		}else if(player1.isTroll == true && player1.object_to_prototype.lusus){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(player1.object_to_prototype.power>200) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
				chatText += chatLine(player1Start, player1, "I suspect it will prove to have been a very bad idea.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
				chatText += chatLine(player1Start, player1, "Agreed.");
			}
		}else if(player1.object_to_prototype.illegal){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "I suspect it will prove to have been a very good idea.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
				chatText += chatLine(player2Start, player2,"Yes.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I suspect it will prove to have been very pointless.");
		}
		return chatText;
	}

	this.academicChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		if(r1.type() == r1.goodBig){
			chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm in the medium!");
		}else{
			chatText += chatLine(player1Start, player1,"Hey, I'm in the medium!");
		}

		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"Oh, man, it's the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"It is so weird! Where even are we compared to our solar system? There's no sun! How does this work!?");
		chatText +=chatLine(player2Start, player2,"Through bullshit hand-wavy game magic. ");
		chatText += chatLine(player1Start, player1,"Oh! I prototyped my kernelsprite with a " + player1.object_to_prototype.htmlTitle() +".\n");
		if(player1.object_to_prototype.player){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that...");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");
		}else if(player1.isTroll == true && player1.object_to_prototype.lusus){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(player1.object_to_prototype.power>200) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(player1.object_to_prototype.illegal){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "So far, it made the enemies look like a  "+player1.object_to_prototype.htmlTitle() + " but I can't wait to find out what else it did!");
				chatText += chatLine(player2Start, player2,"I don't know, it probably did  nothing.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "So far, it made the enemies look like a  "+player1.object_to_prototype.htmlTitle() + " but I can't wait to find out what else it did!");
		}
		return chatText;
	}

	this.popcultureChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";

		chatText += chatLine(player1Start, player1,"Oh man, I'm finally in the medium!");
		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It's the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"So, like, full of " + player1.land.split("Land of ")[1]+". It's just like something out of a VIDEO GAME!");
		chatText +=chatLine(player2Start, player2,"lol, it IS a video game, or did you forget?");
		chatText += chatLine(player1Start, player1,"Well, yeah, but... like... SBURB is not a NORMAL video game. You know what I mean.");
		chatText += chatLine(player1Start, player1,"ANYWAYS... I prototyped my kernel thingy with a " + player1.object_to_prototype.htmlTitle() +".\n");
		if(player1.object_to_prototype.player){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that...");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");
		}else if(player1.isTroll == true && player1.object_to_prototype.lusus){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(player1.object_to_prototype.power>200) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(player1.object_to_prototype.illegal){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "I think it just made the enemies look like a "+player1.object_to_prototype.htmlTitle() + " like a customization kind of thing? ");
				chatText += chatLine(player2Start, player2,"Yeah, that doesn't sound critical for success at all.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I think it just made the enemies look like a "+player1.object_to_prototype.htmlTitle()+ " like a customization kind of thing? ");
		}
		return chatText;
	}

	this.socialChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		if(r1.type() == r1.goodBig){
			chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I made it to the medium safely!");
		}else{
			chatText += chatLine(player1Start, player1,"Hey, I made it to the medium safely!");
		}

		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It's the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"It's chock full of " + player1.land.split("Land of ")[1]+".");
		chatText +=chatLine(player2Start, player2,"lol");
		chatText += chatLine(player1Start, player1,"Have you made it in, yet?");
		if(this.playerList.indexOf(player2) != -1){
			if(player1.fromThisSession(this.session)){
				chatText +=chatLine(player2Start, player2,"Yep, I'm exploring the " + player2.land + ".");
			}else{
				chatText +=chatLine(player2Start, player2,"Yep, it's weird how similar it is to our session.");
			}
			chatText += chatLine(player1Start, player1,"Yay! We're SBURB buddies!");
		}else{
			if(player2.aspect != "Time"){
			chatText +=chatLine(player2Start, player2,"Nope, still waiting.");
			chatText += chatLine(player1Start, player1,"Aww... I'll make sure to grind extra hard to help you out when you're in!");
			chatText +=chatLine(player2Start, player2,"Thanks!");
			}else{
				chatText +=chatLine(player2Start, player2,"Well... I mean... yes and also no?");
				chatText +=chatLine(player2Start, player2,"Past me isn't in yet, but current me (which is future me from your perspective) has been in awhile. Time shenanigans. ");
				chatText += chatLine(player1Start, player1,"!  This game is way more confusing than I thought!");
			}
		}
		chatText += chatLine(player1Start, player1,"So... I prototyped my kernel thingy with a " + player1.object_to_prototype.htmlTitle() +".\n");
		if(player1.object_to_prototype.player){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that...");
			chatText += chatLine(player1Start, player1,":/  Yeah... They figured out a way to not die when they time travel! ");
		}else if(player1.isTroll == true && player1.object_to_prototype.lusus){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... It was so sad when they died. But now I'm happy because SBURB brought them back! ");
			chatText +=chatLine(player2Start, player2,"Oh, man....");
			return chatText; // too depressing to keep going.
		}
		if(player1.object_to_prototype.power>200) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(player1.object_to_prototype.illegal){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "It made the enemies look like a "+player1.object_to_prototype.htmlTitle());
				chatText += chatLine(player2Start, player2,"Yeah, that doesn't sound critical for success at all.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "It made the enemies look like a "+player1.object_to_prototype.htmlTitle());
		}
		return chatText;
	}

	this.getNormalChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		if(r1.type() == r1.goodBig){
			chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm in the medium!");
		}else{
			chatText += chatLine(player1Start, player1,"Hey, I'm in the medium!");
		}

		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It's the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"So, like, full of " + player1.land.split("Land of ")[1]+".");
		chatText +=chatLine(player2Start, player2,"lol");
		chatText += chatLine(player1Start, player1,"So... I prototyped my kernel whatever with a " + player1.object_to_prototype.htmlTitle() +".\n");
		if(player1.isTroll == true && player1.object_to_prototype.lusus){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(player1.object_to_prototype.power>200) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(player1.object_to_prototype.illegal){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "I think it just made the enemies look like a "+player1.object_to_prototype.htmlTitle());
				chatText += chatLine(player2Start, player2,"Yeah, that doesn't sound critical for success at all.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I think it just made the enemies look like a "+player1.object_to_prototype.htmlTitle());
		}
		return chatText;
	}

	this.fantasyChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		if(r1.type() == r1.goodBig){
			chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm in the medium!");
		}else{
			chatText += chatLine(player1Start, player1,"Hey, I'm in the medium!");
		}

		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It's the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"It's so cool! Like something out of a story! I always KNEW I'd have an adventure like this one day!");
		chatText +=chatLine(player2Start, player2,"lol");
		chatText += chatLine(player1Start, player1,"So... I prototyped my kernelsprite with a " + player1.object_to_prototype.htmlTitle() +".\n");
		if(player1.object_to_prototype.player){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that...");
			chatText += chatLine(player1Start, player1,":/  Yeah... That's a story all on it's own. ");
		}else if(player1.isTroll == true && player1.object_to_prototype.lusus){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... That probably wouldn't have happened in a story. ");

		}
		if(player1.object_to_prototype.power>200) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(player1.object_to_prototype.illegal){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "I think it  made the enemies look like a "+player1.object_to_prototype.htmlTitle());
				chatText += chatLine(player2Start, player2,"Yeah, that doesn't sound critical for success at all.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I think it  made the enemies look like a "+player1.object_to_prototype.htmlTitle());
		}
		return chatText;
	}


	this.terribleChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		chatText += chatLine(player1Start, player1,"I am fucking FINALLY in the medium!");

		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It's the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"And I am going to rule it with an iron fist.");
		chatText +=chatLine(player2Start, player2,"lol");
		var born = "born"
		if(player1.isTroll == true){
			born = "hatched"
		}
		chatText += chatLine(player1Start, player1,"Seriously, I was " + born + " for this.");
		chatText += chatLine(player1Start, player1,"I even prototyped my kernel with a " + player1.object_to_prototype.htmlTitle() +".\n");
		if(player1.object_to_prototype.player){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that...");
			chatText += chatLine(player1Start, player1,"Yes! I already have my first minion! ");
		}else	if(player1.isTroll == true && player1.object_to_prototype.lusus){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,"Yes! Who better to assist me on my epic quest? ");

		}
		if(player1.object_to_prototype.power>200) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
				chatText += chatLine(player1Start, player1, "Fuck you. It will obviously give me a huge edge in this game.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
				chatText += chatLine(player1Start, player1, "Fuck you. It will obviously give me a huge edge in this game.");
				chatText += chatLine(player2Start, player2,"Eh.");
			}
		}else if(player1.object_to_prototype.illegal){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "Obviously give me an advantage.");
				chatText += chatLine(player2Start, player2,"Huh. Probably. ");
			}else{
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "Obviously give me an advantage.");

				chatText += chatLine(player2Start, player2,"You know, I think you're right.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I'm not sure NOW, but I just know it'll turn out to have been a good idea.");
			chatText += chatLine(player2Start, player2,"Huh.");
		}
		return chatText;
	}

	this.cultureChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		if(r1.type() == r1.goodBig){
			chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm in the medium!");
		}else{
			chatText += chatLine(player1Start, player1,"Hey, I'm in the medium!");
		}

		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It's the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"So, like, full of " + player1.land.split("Land of ")[1]+". Honestly, I'm a little disappointed in how literal it is.");
		chatText +=chatLine(player2Start, player2,"lol");
		chatText += chatLine(player1Start, player1,"So... I prototyped my kernel with a " + player1.object_to_prototype.htmlTitle() +".\n");
		if(player1.object_to_prototype.player){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that...");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");
		}else if(player1.isTroll == true && player1.object_to_prototype.lusus){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(player1.object_to_prototype.power>200) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(player1.object_to_prototype.illegal){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "I'm not sure. Do you think it was symbolic?");
				chatText += chatLine(player2Start, player2,"No. Probably didn't mean anything at all. I'm sure of it.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. Probably. Symbolic of something cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I'm not sure. Do you think it was symbolic?");
			chatText += chatLine(player2Start, player2,"Huh. Probably.");
		}
		return chatText;
	}

	this.alienChat = function(player1,div){
		//console.log("inside alien chat")
		var player2 = player1.getBestFriend(); //even if they are dead. even if they are from another session.
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";

		if(player2.ectoBiologicalSource == this.session.session_id || player2.ectoBiologicalSource == null){
			//console.log(player2.ectoBiologicalSource)
			if(r1.type() == r1.goodBig){
				chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm finally in your session.");
				chatText += chatLine(player2Start, player2,"Oh wow! What are you going to do? It's not like you have a land or anything...");
				chatText += chatLine(player1Start, player1,"Eh, I'll get things ready for you guys' reckoning. Mess with the Black Queen. Plus, I can always help out you guys with your Land Quests.");
				chatText += chatLine(player2Start, player2,"Oh yeah...");
			}else if(r1.type() == r1.badBig){
				chatText += chatLine(player1Start, player1, "So I guess today is finally the day you fuck everything up.")
				chatText += chatLine(player2Start, player2,"God, you are such an asshole. Just because you fucked your session up doesn't mean we will!");
				chatText += chatLine(player1Start, player1, "You are just not getting it. This game only has one level: fucking everything up.")
			}else{
				chatText += chatLine(player1Start, player1,"Hey, I'm finally in your session.");
				chatText += chatLine(player2Start, player2,"Oh wow! What are you going to do? It's not like you have a land or anything...");
				chatText += chatLine(player1Start, player1,"Eh, I'll get things ready for you guys' reckoning. Mess with the Black Queen. Plus, I can always help out you guys with your Land Quests.");
				chatText += chatLine(player2Start, player2,"Oh yeah...");
			}


		}else{
				if(player2.dead){
					//console.log("player 2 is: " + player2.title())
					//console.log(player2)
					chatText += chatLine(player1Start, player1, "So. Uh. Hey, I'm finally in the new session I was telling you about.");
					chatText += chatLine(player1Start, player1, "You would have loved it.");
					chatText += chatLine(player1Start, player1, "Don't worry. I'll make sure it will all have been worth it. A whole new universe, a second chance.");
					chatText += chatLine(player1Start, player1, "...");
					chatText += chatLine(player1Start, player1, "Goodbye.");
				}else{

						chatText += chatLine(player1Start, player1,"Hey, I'm finally in the new session.");
						chatText += chatLine(player2Start, player2,"Ugh. I am just ready to be DONE playing this game.");
						chatText += chatLine(player1Start, player1,"I know right? At least this time we don't have to worry about all those bullshit sidequests.");
						chatText += chatLine(player2Start, player2,"Yes, we can just focus on getting ready for the end game.");

				}

		}
		drawChat(document.getElementById("canvas"+ (div.attr("id"))), player1, player2, chatText, repeatTime,"discuss_sburb.png");
		return null;
	}

	this.getChat = function(player1, player2,div){

		if(!player1.fromThisSession(this.session) || !player1.land){
			return this.alienChat(player1,div);
		}

		if(player2.grimDark > 1){
			 return this.grimPlayer2Chat(player1, player2);
		}

		if(player1.aspect == "Light" || player1.class_name == "Seer"){
			return this.lightChat(player1, player2);
		}
		if(playerLikesCulture(player1)){
			return this.cultureChat(player1, player2);
		}

		if(playerLikesTerrible(player1)){
			return this.terribleChat(player1, player2);
		}

		if(playerLikesAcademic(player1)){
			return this.academicChat(player1, player2);
		}

		if(playerLikesPopculture(player1)){
			return this.popcultureChat(player1, player2);
		}

		if(playerLikesSocial(player1)){
			return this.socialChat(player1, player2);
		}

		if(playerLikesFantasy(player1) || playerLikesWriting(player1) ){
			return this.fantasyChat(player1, player2);
		}

		return this.getNormalChat(player1, player2);
	}

	//TODO consider making this a method in handleSprites, so ALL scenes can get at it.
	//make a pesterchum skin and stick text into it. How much can I fit?
	//describe what land is like "It's full of...Peace", get word that isn't 'Land', 'of' or 'and'.
	this.chat = function(div){
		var repeatTime = 1000;
		var canvasHTML = "<br><canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//first, find/make pesterchum skin. Want it to be no more than 300 tall for now.
		//then, have some text I want to render to it.
		//filter through quirks, and render.  (you can splurge and make more quirks here, future me)
		//does it fit in screen? If it doesn't, what should i do? scroll bars? make pesterchum taller?
		//do what homestuck does and put some text in image but rest in pesterlog?
		//when trolls happen, should they use trollian?
		var player1 = this.player;

		var player2 = player1.getBestFriendFromList(findLivingPlayers(this.session.players), "intro chat");
		if(player2 == null){
			player2 = player1.getWorstEnemyFromList(findLivingPlayers(this.session.players));

		}


		if(player2 == null){
			return div.append(this.content()); //give up, forever alone.

		}



		var chatText = this.getChat(player1,player2,div);
		if(chatText == null){//alien chat
			return;
		}
		//alien chat won't get here, renders itself cause can talk to dead
		drawChat(document.getElementById("canvas"+ (div.attr("id"))), player1, player2, chatText, repeatTime,"discuss_sburb.png");
	}

	//i is so you know entry order
	this.renderContent = function(div,i){
		//foundRareSession(div, "This is just a test. " + this.session.session_id)
		var canvasHTML = "<canvas style='display:none' class = 'charSheet' id='firstcanvas" + this.player.id+"_" + this.session.session_id+"' width='400' height='1000'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = document.getElementById("firstcanvas"+ this.player.id+"_" + this.session.session_id);
		drawCharSheet(canvasDiv,this.player)
		this.player.generateDenizen();
		var alt = this.addImportantEvent();
		if(alt && alt.alternateScene(div)){
			return;
		}
		var narration = ""

		if(this.player.land == null){
			//console.log("This session is:  " + this.session.session_id + " and the " + this.player.title() + " is from session: " + this.player.ectoBiologicalSource + " and their land is: " + this.player.land);
		}
		if(!this.player.fromThisSession(this.session) || !this.player.land){
			narration += "<br>The " + this.player.htmlTitle() + " has been in contact with the native players of this session for most of their lives. It's weird how time flows differently between universes. Now, after inumerable shenanigans, they will finally be able to meet up face to face."
			if(this.player.dead==true){
				console.log(session.session_id + " dead player enters, " +this.player.title())
				narration+= "Wait. What?  They are DEAD!? How did that happen? Shenenigans, probably. I...I guess time flowing differently between universes is still a thing that is true, and they were able to contact them even before they died.  Shit, this is extra tragic.  <br>"
				div.append(narration);
				this.session.availablePlayers.push(this.player);
				return;
			}
		}else{
			this.changePrototyping(div);
			narration += "<br>The " + this.player.htmlTitle() + " enters the game " + indexToWords(i) + ". ";
			if(this.player.aspect == "Void") narration += "They are " + this.player.voidDescription() +". ";
			narration += " They manage to prototype their kernel sprite with a " + this.player.object_to_prototype.htmlTitle() + " pre-entry. "
			narration += this.corruptedSprite();

			narration += " They have many INTERESTS, including " +this.player.interest1 + " and " + this.player.interest2 + ". ";
			narration += " Their chat handle is " + this.player.chatHandle + ". "
			if(this.player.leader){
				narration += "They are definitely the leader.";
			}
			if(this.player.godDestiny){
				narration += " They appear to be destined for greatness. ";
			}

			if(this.player.minLuck + this.player.maxLuck >25){
				//console.log("initially lucky player: " +this.session.session_id)
				narration += " They have aaaaaaaall the luck. All of it.";
			}

			if(this.player.maxLuck < -25){
				//console.log("initially unlucky player: " +this.session.session_id)
				narration += " They have an insurmountable stockpile of TERRIBLE LUCK.";
			}
			
			if(this.player.fraymotifs.length > 0){
				//console.log("initially unlucky player: " +this.session.session_id)
				narration += " They have special powers, including " + turnArrayIntoHumanSentence(this.player.fraymotifs) + ". ";
			}

			if(this.player.dead==true){
				console.log(session.session_id + " dead player enters, " +this.player.title())
				narration+= "Wait. What?  They are DEAD!? How did that happen? Shenenigans, probably. I...I guess their GHOST or something is making sure their house and corpse makes it into the medium? And their client player, as appropriate. Their kernel somehow gets prototyped with a "+this.player.object_to_prototype.htmlTitle() + ". ";
				this.player.timesDied ++;
				this.session.availablePlayers.push(this.player);
				this.player.sprite.addPrototyping(this.player.object_to_prototype); //hot damn this is coming together.
				if(this.session.kingsScepter) this.session.kingsScepter.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
				if(this.player.object_to_prototype.armless){
					console.log("armless prototyping in session: " + this.session.session_id)
					narration += "Huh. Of all the things to take from prototyping a " + this.player.object_to_prototype.name + ", why did it have to be its fingerless attribute? The Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is now useless. If any carapacian attempts to put it on, they lose the finger it was on, which makes it fall off.  She destroys the RING in a fit of vexation. "
					this.session.destroyBlackRing();
				}
				if(this.session.queensRing){
					this.session.queensRing.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
					narration += "The Black Queen's RING OF ORBS "+ this.session.convertPlayerNumberToWords() + "FOLD grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
				}
			narration += "The Black King's SCEPTER grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
				div.append(narration);

				return;
			}

			narration += this.changeBoggle();
			narration += this.corruptedLand();

			for(var j = 0; j<this.player.relationships.length; j++){
				var r = this.player.relationships[j];
				//console.log("Initial relationship value is: " + r.value + " and grim dark is: " + this.player.grimDark)
				if(r.type() != "Friends" && r.type() != "Rivals"){
					narration += "They are " + r.description() + ". ";
				}
			}
			if(this.player.trickster){
				narration += "They immediately heal their land in an explosion of bullshit candy giggle-magic. ";
			}
			this.player.sprite.addPrototyping(this.player.object_to_prototype); //hot damn this is coming together.
			if(this.session.kingsScepter) this.session.kingsScepter.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
			if(this.player.object_to_prototype.armless && Math.seededRandom() > 0.93){
					console.log("armless prototyping in session: " + this.session.session_id)
					narration += "Huh. Of all the things to take from prototyping a " + this.player.object_to_prototype.name + ", why did it have to be its fingerless attribute? The Black Queen's RING OF ORBS " + this.session.convertPlayerNumberToWords() + "FOLD is now useless. If any carapacian attempts to put it on, they lose the finger it was on, which makes it fall off.  She destroys the RING in a fit of vexation. "
					this.session.destroyBlackRing();
			}
			if(this.session.queensRing){
				this.session.queensRing.addPrototyping(this.player.object_to_prototype); //assume king can't lose crown for now.
				narration += "The Black Queen's RING OF ORBS "+ this.session.convertPlayerNumberToWords() + "FOLD grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
			}
			narration += "The Black King's SCEPTER grows stronger from prototyping the " +  this.player.object_to_prototype.name +". ";
		}
		div.append(narration);
		this.chat(div);
		this.session.availablePlayers.push(this.player);
	}

	this.content = function(div, i){
		//var ret = " TODO: Figure out what a non 2.0 version of the Intro scene would look like. "
		//div.append(ret);
	}
}
