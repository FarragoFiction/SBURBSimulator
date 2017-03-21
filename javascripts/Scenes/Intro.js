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

	this.grimPlayer2Chat = function( player1, player2){
			var r1 = player1.getRelationshipWith(player2);
			var player1Start = player1.chatHandleShort()+ ": "
			var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
			chatText += chatLine(player1Start, player1,"A " + player1.kernel_sprite +".\n");
			chatText += chatLine(player2Start, player2,"Social obligation complete. Goodbye.");
			return chatText;
	}

	this.lightChat = function(player1,player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		if(r1.type() == r1.goodBig){
			chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm in the medium!");
		}else{
			chatText += chatLine(player1Start, player1,"Hey, I'm in the medium!");
		}

		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It appears to be the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"I guess it has something to do with my title? I am apparently the ' " + player1.title() + "'. ");
		chatText +=chatLine(player2Start, player2,"Whatever THAT means. ");
		chatText += chatLine(player1Start, player1,"Yes. Also, I prototyped my kernelsprite with a " + player1.kernel_sprite +".\n");
		if(player1.isTroll == true){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... I think SBURB hates guardians. ");

		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
				chatText += chatLine(player1Start, player1, "I suspect it will prove to have been a very bad idea.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
				chatText += chatLine(player1Start, player1, "Agreed.");
			}
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
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
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		chatText += chatLine(player1Start, player1,"Oh! I prototyped my kernelsprite with a " + player1.kernel_sprite +".\n");
		if(player1.isTroll == true){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "So far, it made the enemies look like a  "+player1.kernel_sprite + " but I can't wait to find out what else it did!");
				chatText += chatLine(player2Start, player2,"I don't know, it probably did  nothing.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "So far, it made the enemies look like a  "+player1.kernel_sprite + " but I can't wait to find out what else it did!");
		}
		return chatText;
	}

	this.popcultureChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";

		chatText += chatLine(player1Start, player1,"Oh man, I'm finally in the medium!");
		chatText += chatLine(player2Start, player2,"Good, what's it like?");
		chatText += chatLine(player1Start, player1,"It's the " + player1.land +".");
		chatText += chatLine(player1Start, player1,"So, like, full of " + player1.land.split("Land of ")[1]+". It's just like something out of a VIDEO GAME!");
		chatText +=chatLine(player2Start, player2,"lol, it IS a video game, or did you forget?");
		chatText += chatLine(player1Start, player1,"Well, yeah, but... like... SBURB is not a NORMAL video game. You know what I mean.");
		chatText += chatLine(player1Start, player1,"ANYWAYS... I prototyped my kernel thingy with a " + player1.kernel_sprite +".\n");
		if(player1.isTroll == true){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "I think it just made the enemies look like a "+player1.kernel_sprite + " like a customization kind of thing? ");
				chatText += chatLine(player2Start, player2,"Yeah, that doesn't sound critical for success at all.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I think it just made the enemies look like a "+player1.kernel_sprite+ " like a customization kind of thing? ");
		}
		return chatText;
	}

	this.socialChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		chatText += chatLine(player1Start, player1,"So... I prototyped my kernel thingy with a " + player1.kernel_sprite +".\n");
		if(player1.isTroll == true){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... It was so sad when they died. But now I'm happy because SBURB brought them back! ");
			chatText +=chatLine(player2Start, player2,"Oh, man....");
			return chatText; // too depressing to keep going.
		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "It made the enemies look like a "+player1.kernel_sprite);
				chatText += chatLine(player2Start, player2,"Yeah, that doesn't sound critical for success at all.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "It made the enemies look like a "+player1.kernel_sprite);
		}
		return chatText;
	}

	this.getNormalChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		chatText += chatLine(player1Start, player1,"So... I prototyped my kernel whatever with a " + player1.kernel_sprite +".\n");
		if(player1.isTroll == true){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "I think it just made the enemies look like a "+player1.kernel_sprite);
				chatText += chatLine(player2Start, player2,"Yeah, that doesn't sound critical for success at all.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I think it just made the enemies look like a "+player1.kernel_sprite);
		}
		return chatText;
	}

	this.fantasyChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		chatText += chatLine(player1Start, player1,"So... I prototyped my kernelsprite with a " + player1.kernel_sprite +".\n");
		if(player1.isTroll == true){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... That probably wouldn't have happened in a story. ");

		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"What did that do?");
				chatText += chatLine(player1Start, player1, "I think it  made the enemies look like a "+player1.kernel_sprite);
				chatText += chatLine(player2Start, player2,"Yeah, that doesn't sound critical for success at all.");
			}else{
				chatText += chatLine(player2Start, player2,"Huh. That sounds cool.");
			}
		}else{
			chatText += chatLine(player2Start, player2,"What did that do?");
			chatText += chatLine(player1Start, player1, "I think it  made the enemies look like a "+player1.kernel_sprite);
		}
		return chatText;
	}


	this.terribleChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		chatText += chatLine(player1Start, player1,"I even prototyped my kernel with a " + player1.kernel_sprite +".\n");
		if(player1.isTroll == true){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,"Yep! Who better to assist me on my epic quest? ");

		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
				chatText += chatLine(player1Start, player1, "Fuck you. It will obviously give me a huge edge in this game.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
				chatText += chatLine(player1Start, player1, "Fuck you. It will obviously give me a huge edge in this game.");
				chatText += chatLine(player2Start, player2,"Eh.");
			}
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
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
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
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
		chatText += chatLine(player1Start, player1,"So... I prototyped my kernel with a " + player1.kernel_sprite +".\n");
		if(player1.isTroll == true){
			chatText +=chatLine(player2Start, player2,"Wait! Isn't that your Lusus!?");
			chatText += chatLine(player1Start, player1,":/  Yeah... Long story. ");

		}
		if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
			if(player2.aspect != "Light" && player2.class_name != "Seer"){
				chatText += chatLine(player2Start, player2,"That will probably have zero serious, long term consequences.");
			}else{
				chatText += chatLine(player2Start, player2,"Somehow, I have a bad feeling about that.");
			}
		}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
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
	
	this.alienChat = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ":"; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		if(r1.type() == r1.goodBig){
			chatText += chatLine(player1Start, player1, "Uh, Hey, I wanted to tell you, I'm finally in your session.");
		}else{
			chatText += chatLine(player1Start, player1,"Hey, I'm finally in your session.");
		}
		return chatText;
	}

	this.getChat = function(player1, player2){
		if(!player1.fromThisSession(this.session)){
			return this.alienChat(player1,player2);
		}
		
		if(player2.grimDark == true){
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

		

		var chatText = this.getChat(player1,player2);
		//don't need timeout here.
		drawChat(document.getElementById("canvas"+ (div.attr("id"))), player1, player2, chatText, repeatTime);
	}

	//i is so you know entry order
	this.renderContent = function(div,i){
		var narration = "";
		if(this.player.land == null){
			//console.log("This session is:  " + this.session.session_id + " and the " + this.player.title() + " is from session: " + this.player.ectoBiologicalSource + " and their land is: " + this.player.land);
		}
		if(!this.player.fromThisSession(this.session)){
			narration += "<br>The " + this.player.htmlTitle() + " has been in contact with the native players of this session for most of their lives. It's weird how time flows differently between universes. Now, after inumerable shenanigans, they will finally be able to meet up face to face." 
		}else{
			narration += "<br>The " + this.player.htmlTitle() + " enters the game " + indexToWords(i) + ". ";

			narration += " They have many INTERESTS, including " +this.player.interest1 + " and " + this.player.interest2 + ". ";
			narration += " Their chat handle is " + this.player.chatHandle + ". "
			if(this.player.leader){
				narration += "They are definitely the leader.";
			}
			if(this.player.godDestiny){
				narration += " They appear to be destined for greatness. ";
			}

			if(this.player.dead==true){
				console.log(session.session_id + " dead player enters, " +this.player.title())
				narration+= "Wait. What?  They are DEAD!? How did that happen? Shenenigans, probably."
				div.append(narration);
				this.session.availablePlayers.push(this.player);
				return;
			}

			narration += " They boggle vacantly at the " + this.player.land + ". ";

			for(var j = 0; j<this.player.relationships.length; j++){
				var r = this.player.relationships[j];
				if(r.type() != "Friends" && r.type() != "Rivals"){
					narration += "They are " + r.description() + ". ";
				}
			}

			this.session.kingStrength = this.session.kingStrength + 20;
			if(this.session.queenStrength > 0){
				this.session.queenStrength = this.session.queenStrength + 10;
			}
			if(disastor_prototypings.indexOf(this.player.kernel_sprite) != -1) {
				this.session.kingStrength = this.session.kingStrength + 200;
				if(this.session.queenStrength > 0){
					this.session.queenStrength = this.session.queenStrength + 100;
				}

			}else if(fortune_prototypings.indexOf(this.player.kernel_sprite) != -1){
			}		
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
