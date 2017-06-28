//only one player at a time.
//compare old relationship with new relationship.
function RelationshipDrama(session){
	this.session = session;
	this.canRepeat = true;
	this.playerList = [];  //what players are already in the medium when i trigger?
	this.dramaPlayers = [];

	this.trigger = function(playerList){
		this.playerList = playerList;
		this.dramaPlayers = [];
		//CAN change how ou feel about somebody not yet in the medium
		for(var i = 0; i< playerList.length; i++){
			var p = playerList[i];
			if(p.hasRelationshipDrama() && p.dead == false){ //stop corpse confessions!
				this.dramaPlayers.push(p)
			}
		}
		return this.dramaPlayers.length > 0;
	}

	//if you're p1, then don't even start this confession, add yourself back to available players.
	//this is sort of like a fantasy.
	//if you'e p2, reject your suitor because you are taken
	this.dontCheatOnQuadrantMate = function(player,potentialMate){
		console.log("TODO")
		var r = player.getRelationshipWith(potentialMate);
	}

	//if you're p1, then don't even start this confession, add yourself back to available players.
	//this is sort of like a fantasy. why isnt your crush single???
	//if you'e p2, reject your suitor because they are taken and apparently skeezy???
	this.dontAllowCheatingOnQuadrantMate = function(player, potentialMate){
		console.log("TODO")
	}

	//if they hate you back
	this.celebratoryRapBattle = function(div, player1, player2){
		//console.log("celbratory rap battles: " + this.session.session_id)
		this.session.rapBattle = true;
		var divId = (div.attr("id")) + player1.chatHandle + player1.id;
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var canvasHTML = "<br><canvas id='canvas" + divId +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = document.getElementById("canvas"+  divId);
		var chatText = ""

		chatText += chatLine(player1Start, player1,"Bro. Rap Battle. Now. Bring the Fires. Imma show you why you suck.")
		chatText += chatLine(player2Start, player2,"Yes. Fuck yes! Hell FUCKING yes!")
		var p1score = 0;
		var p2score = 0;
		var raps1 = getRapForPlayer(player1,"",0);
		chatText += raps1[0];
		p1score = raps1[1];
		var raps2 = getRapForPlayer(player2,"",0);
		chatText += raps2[0];
		p2score = raps1[1];
		drawChat(canvasDiv, player1, player2, chatText, repeatTime,"discuss_raps.png");
		if(p1score + p2score > 6){ //it's not winning that calms them down, but sick fires in general.
			//console.log("rap sick fires in session: " + this.session.session_id + " score: " + (p1score + p2score))
			div.append("<img class = 'sickFiresCentered' src = 'images/sick_fires.gif'><br> It seems that the " + player1.htmlTitle() + " has been calmed down, for now.");
			if(player1.murderMode) player1.unmakeMurderMode(); //if they WERE in murder mode, well, now they ain't.
			if(player2.murderMode) player2.unmakeMurderMode();
			//rap battles are truly the best way to power level.
			player1.increasePower();
			player2.increasePower();
			this.session.sickFires = true;
		}

	}

	//poor eridan?
	this.confessTooManyFeeling = function(div, player, crush){
		var relationship = player.getRelationshipWith(crush);
		var makeHate = false;
		//different format for canvas code

		var chatText = "";
		var player1 = player;
		var player2 = crush;

		var divID = (div.attr("id")) + "_" + player.chatHandle+"confess_crush_"+crush.chatHandle + player.id;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = document.getElementById("canvas"+ divID);
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

		chatText += chatLine(player1Start, player1, "So... hey.");
		chatText += chatLine(player2Start, player2, "Hey?");

		chatText += chatLine(player1Start, player1, "I feel like an asshole.");
		chatText += chatLine(player1Start, player1, "I have had so many fucking crushes. ");
		chatText += chatLine(player1Start, player1, "I'd understand if you didn't take me seriously. But I like you. A lot.");

		player1.number_confessions ++;
		player2.number_times_confessed_to ++;


		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);

		if(r2.saved_type == r2.goodBig){
			chatText += chatLine(player2Start, player2,"!");
			chatText += chatLine(player2Start, player2,"Wow... I ... I feel the same way!");
			chatText += chatLine(player1Start, player1,"Holy shit! Even though I've been hitting on everybody?");
			chatText += chatLine(player2Start, player2,"Honestly, I was kind of insulted you hit on everybody BUT ME.");
			chatText += chatLine(player1Start, player1,"Holy shit.");
			this.session.hasHearts = true;
			makeHeart(player1, player2);
		}else if(r2.saved_type ==r2.badBig){
			chatText += chatLine(player2Start, player2, "lol");
			chatText += chatLine(player2Start, player2, "You really think I'm dumb enough to fall for that?");
			chatText += chatLine(player2Start, player2, "You are " + this.generateNewOpinion(r2) + "!");
			chatText += chatLine(player2Start, player2, "so fuck off!");
			makeHate = true;
			//don't set hate here. Even though player is confessing flushed, shows them with a spade 'cause now they hate their crush.
			//this is not going to go well.
		}else{
			if(player2.grimDark > 3){
				chatText += chatLine(player2Start, player2,"Your feelings are irrelevant. Your promiscuity is irrelevant.");
				chatText += chatLine(player1Start, player1,"Fuck. You're grimdark, aren't you. Fuck. I've made a huge mistake.");
				player1.sanity += -10;
			}else{
				chatText += chatLine(player2Start, player2,"Fuck. I'm sorry. I just don't feel that way about you. ");
				if(playerLikesRomantic(player1) || player1.aspect == "Mind"){
					chatText += chatLine(player1Start, player1,"Fuck. I'm sorry I didn't keep it to myself. ");
					if(playerLikesRomantic(player2) || player2.aspect == "Mind" || player2.aspect == "Rage"){
						chatText += chatLine(player2Start, player2,"Better than keeping it bottled up. ");
					}
					player1.sanity += -10;
				}else if(player1.class_name == "Bard" || player2.aspect == "Rage" || playerLikesTerrible(player1)){
					chatText += chatLine(player1Start, player1,"Fuck. Why don't I ever learn that people suck?");
					if(player2.class_name == "Seer" || player2.aspect == "Blood" || playerLikesRomantic(player2)){
						chatText += chatLine(player2Start, player2,"Holy fucking shit. And you wonder why nobody likes you? ");
						var makeHate = true;  //easier to hate after so many rejections. poor eridan.
					}
					player1.sanity += -10;
				}else if(player1.class_name == "Page" || player2.aspect == "Blood" || playerLikesAcademic(player1)){
					chatText += chatLine(player1Start, player1,"But... I was even brave and told you and everything...");
					if(player2.class_name == "Knight" || player2.aspect == "Rage" || playerLikesAcademic(player2)){
						chatText += chatLine(player2Start, player2,"Fuck. But you've been 'brave' enough to hit on EVERYBODY! ");
						chatText += chatLine(player1Start, player1,"What else am I supposed to do? Ignoring how I feel is cowardice, right?");
						chatText += chatLine(player2Start, player2,"Man, it's like your emotions are calibrated wrong. I can't just tell you 'fall in love less easily'. Fuck.");
						player1.sanity += -10;
					}else{
						chatText += chatLine(player2Start, player2,"I don't know what to tell you. ");
						chatText += chatLine(player1Start, player1,"Fuck");
					}

				}else{
					chatText += chatLine(player1Start, player1,"Oh. Yes. That's what I expected.");
					player1.sanity += -10;
				}
			}

			if(player2.number_times_confessed_to > 3){
				chatText += chatLine(player2Start, player2,"What is it with everybody having a crush on me? ");
			}
		}
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		drawRelationshipChat(canvasDiv, player1, player2, chatText, 1000);

		if(makeHate == true){
			player1.sanity += -10;
			r1.value = -20;
		}

	}


	this.confessFeelings = function(div, player,crush){
		//debug("confession!!!")
		var relationship = player.getRelationshipWith(crush);
		var makeHate = false;

		//different format for canvas code

		var chatText = "";
		var player1 = player;
		var player2 = crush;
		//already set player unavailable
		removeFromArray(crush, this.session.availablePlayers);

		if(crush.dead == true){
			var narration = "<br>The " + player.htmlTitle() + " used to think that the " + crush.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			narration += " It's especially tragic that they didn't realize this until the " + crush.htmlTitle() + " died.";
			div.append(narration);
			return;
		}
		if(player1.number_confessions > 3){
			//alert("why can't I hold all these feels?")
			return this.confessTooManyFeeling(div, player, crush); //don't just keep spinning your wheels.
		}
		var divID = (div.attr("id")) + "_" + player.chatHandle+"confess_crush_"+crush.chatHandle+ player.id;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = document.getElementById("canvas"+ divID);
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.

		chatText += chatLine(player1Start, player1, "So... hey.");
		chatText += chatLine(player2Start, player2, "Hey?");
		chatText += chatLine(player1Start, player1, "I have no idea how to say this so I'm just going to do it.");
		chatText += chatLine(player2Start, player2, "?");
		chatText += chatLine(player1Start, player1, "I like you.  Romantically.");
		player1.number_confessions ++;
		player2.number_times_confessed_to ++;
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);

		if(r2.saved_type == r2.goodBig){
			chatText += chatLine(player2Start, player2,"!");
			chatText += chatLine(player2Start, player2,"Wow... I ... I feel the same way!");
			chatText += chatLine(player1Start, player1,"Holy shit!");
			makeHeart(player1, player2);
			this.session.hasHearts = true;
		}else if(r2.saved_type ==r2.badBig){
			chatText += chatLine(player2Start, player2, "lol");
			chatText += chatLine(player2Start, player2, "Well, I think YOU are " + this.generateNewOpinion(r2) + "!");
			chatText += chatLine(player2Start, player2, "so fuck off!");
			makeHate = true;
			//don't set hate here. Even though player is confessing flushed, shows them with a spade 'cause now they hate their crush.
			//this is not going to go well.
		}else{
			if(player2.grimDark  > 3){
				chatText += chatLine(player2Start, player2,"Your feelings are irrelevant. ");
				chatText += chatLine(player1Start, player1,"Fuck. You're grimdark, aren't you. Fuck.");
				player1.sanity += -10;
			}else{
				chatText += chatLine(player2Start, player2,"Fuck. I'm sorry. I just don't feel that way about you. ");
				if(playerLikesRomantic(player1) || player1.aspect == "Mind"){
					chatText += chatLine(player1Start, player1,"Fuck. Thanks for being honest. ");
					player1.sanity += -0.5; //not triggered MUCH, but keeps them from continuing to confess to other people. I mean. Hypothetically.
				}else if(player1.class_name == "Bard" || player2.aspect == "Rage" || playerLikesTerrible(player1)){
					chatText += chatLine(player1Start, player1,"But... but...WHY!? I tried so hard to be nice to you!");
					if(player2.class_name == "Seer" || player2.aspect == "Blood" || playerLikesRomantic(player2)){
						chatText += player2Start+"  Look, I'll level with you. I'm even dropping my dumb quirk, okay? It doesn't matter if you're nice. I'm sorry.  I can't just change the way I feel just because maybe you deserve it.\n";
					}else{
						chatText += chatLine(player2Start, player2,"Fuck. I just don't. I'm sorry. ");
					}
					chatText += chatLine(player1Start, player1,"Fuck.");
					player1.sanity += -0.5;
				}else if(player1.class_name == "Page" || player2.aspect == "Blood" || playerLikesAcademic(player1)){
					chatText += chatLine(player1Start, player1,"But... I was even brave and told you and everything...");
					if(player2.class_name == "Knight" || player2.aspect == "Rage" || playerLikesCulture(player2)){
						chatText += chatLine(player2Start, player2,"And that's really impressive! But... I can't MAKE myself like you back? You know? ");
						chatText += chatLine(player1Start, player1,"I know...");
					}else if(player2.class_name == "Page" || player2.aspect == "Blood" || playerLikesAcademic(player2)){
						chatText += chatLine(player2Start, player2,"And I get that! And I wish I liked you back. But I don't.");
						chatText += chatLine(player1Start, player1,"Fuck.");
					}else{
						chatText += chatLine(player2Start, player2,"I don't know what to tell you. ");
						chatText += chatLine(player1Start, player1,"Fuck");
					}

				}else{
					chatText += chatLine(player1Start, player1,"Oh.");
					player1.sanity += -0.5;
				}
			}
			if(player2.number_times_confessed_to > 3){
				chatText += chatLine(player2Start, player2,"What is it with everybody having a crush on me? ");
			}

		}

		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		drawRelationshipChat(canvasDiv, player1, player2, chatText, 1000);
		if(makeHate == true){
			player1.sanity += -10;
			r1.value = -20;
		}
	}

	/* DestroyerTerraria suggests:
	"XX is SUCH a goddamn asshole!"

"They're the worst!"

"Are you even listening, dude?"

"Dude c'mon, they suck. (You agree with me, I know that/ I know you're on the fence about them, but that's no reason for the silent treatment/ I know you like them, but don't they aggravate you at least a little?)"

"...dude?"

"... oh shit you're dead aren't you."

	*/
	this.corpseVent = function(div, player1, player2, crush){
		//alert("tell jadedResearcher you saw  corpse vent in session: " + this.session.session_id)
		var relationship = player1.getRelationshipWith(crush);
		var chatText = "";

		var divID = (div.attr("id")) + "_" + player1.chatHandle+"advice_crush_"+crush.chatHandle + player1.id;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		player1.sanity += 1;  //talking about it helps.
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1)
		var chatText = "";
		var trait = whatDontPlayersHaveInCommon(player1, crush);
		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player1Start, player1,"So... " + crush.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
		chatText += chatLine(player1Start, player1,"Shit...I just want to punch them in their " + trait + " face.");
		chatText += chatLine(player1Start, player1,"Fuck. I need to just avoid them. This stupid game is dangerous enough without me flying off the handle. ");
		chatText += chatLine(player1Start, player1,"You're always so good at advice.  Thanks!");
		drawChat(canvasDiv, player1, player2, chatText, 1000,"discuss_hatemance.png");
	}

	this.corpseAdvice = function(div, player1, player2, crush){
		//alert("tell jadedResearcher you saw corpse advice in session: " + this.session.session_id)
		var relationship = player1.getRelationshipWith(crush);
		var chatText = "";

		var divID = (div.attr("id")) + "_" + player1.chatHandle+"advice_crush_"+crush.chatHandle + player1.id;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		player1.sanity += 1;  //talking about it helps.
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1)
		var chatText = "";
		//console.log("player1: " + player1.title() + 'player2: ' + player2.title())
		var trait = whatDoPlayersHaveInCommon(player1, crush);
		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player1Start, player1,"So... " + crush.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
	  chatText += chatLine(player1Start, player1,"Like, maybe I didn't see that at first, but now all I can do is think about how " + trait + " they are.");
		chatText += chatLine(player1Start, player1,"Shit... maybe I should just tell them? God, why is it so hard being in love. It's hard and nobody understands.");
		chatText += chatLine(player1Start, player1,"You're right. I'm going to tell them. Soon. When the time is right. ");
		chatText += chatLine(player1Start, player1,"You're always so good at advice.  Thanks!");
		drawChat(canvasDiv, player1, player2, chatText, 1000,"discuss_romance.png");
	}

	//goes different if best friend has crush on player
	//or on crushee.
	this.relationshipAdvice = function(div,player,crush){
		var relationship = player.getRelationshipWith(crush);


		var chatText = "";
		var player1 = player;
		var player2 = this.getBestFriendBesidesCrush(player, crush); //this is currently returnin the crush in question. why?

		if(!player2 || player2 == crush){
			var narration = "<br>The " + player.htmlTitle() + " used to think that the " + crush.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			if(crush.dead == true){
				narration += " It's especially tragic that they didn't realize this until the " + crush.htmlTitle() + " died.";
			}
			narration += " It's a shame the " + player.htmlTitle() + " has nobody to talk to about this. ";
			div.append(narration);
			return;
		}
		if(player2.dead == true){
			return this.corpseAdvice(div,player1,player2,crush);
		}
		removeFromArray(player2, this.session.availablePlayers);

		var divID = (div.attr("id")) + "_" + player.chatHandle+"advice_crush_"+crush.chatHandle + player.id;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		player.sanity += 3;  //talking about it helps.
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);
		var r2crush = player2.getRelationshipWith(crush);  //sometimes crush is same as best friend...despite all my best efforts.
     //console.log("Crush: " + crush.title()) //these are occasionally the same despite my best efforts
		 //console.log("Player2: " + player2.title())

		//alert("I am: " + player2.title() + " and my relationship with : " + crush.title() + " is being checked")
		var chatText = "";

		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"So... " + crush.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
		if(crush.dead == true){
			player.sanity += -20;  //still hurts that they are dead.
			chatText += chatLine(player2Start, player2,"Oh my god, you know they are dead, right?");
			chatText += chatLine(player1Start, player1,"Yeah. Fuck. Why didn't I notice them sooner?");
			chatText += chatLine(player2Start, player2,"Fuck. That sucks. I'm here for you.");
			chatText += chatLine(player1Start, player1,"Thanks. Fuck. This game sucks.");
			chatText += chatLine(player2Start, player2,"It really, really does.");
		}else{
			if(r2crush && r2crush.saved_type == r2crush.goodBig){ //best friend has a crush on them, too.
				//try to put aside feelings
				if(player2.class_name == "Page" || player2.class_name == "Maid" || player2.class_name == "Sylph" || player2.aspect == "Blood"){
					chatText += chatLine(player2Start, player2,"Wow! You should definitely, definitely tell them that! Right away!");
					chatText += chatLine(player1Start, player1,"You think so?");
					chatText += chatLine(player2Start, player2,"Absolutely.");
				}else if(player2.class_name == "Knight" || player2.class_name == "Seer" || player2.class_name == "Heir" || player2.aspect == "Mind"){ //fight player1
					chatText += chatLine(player2Start, player2,"Fuck! I like them, too.");
					chatText += chatLine(player1Start, player1,"Well, fuck.");
					chatText += chatLine(player1Start, player1,"At least we have good taste?");
				}else{  //try to ignore feelings
					chatText += chatLine(player2Start, player2,"Oh?");
					chatText += chatLine(player2Start, player2,"I, hadn't noticed?");
					chatText += chatLine(player2Start, player2,"I guess I can see that. If that's your thing.");
					chatText += chatLine(player1Start, player1,"They are amazing...");
					r2.decrease();
				}
			}else if(r2crush && r2crush.saved_type == r2crush.badBig){ //friend thinks they are an asshole.
				if(player2.class_name == "Page" || player2.class_name == "Maid" || player2.class_name == "Sylph" || player2.aspect == "Blood"){
					chatText += chatLine(player2Start, player2,"Wow! Huh. You should follow your heart.");
					chatText += chatLine(player1Start, player1,"You think so?");
					chatText += chatLine(player2Start, player2,"Absolutely.");
				}else if(player2.class_name == "Knight" || player2.class_name == "Seer" || player2.class_name == "Heir" || player2.aspect == "Mind"){ //fight player1
					chatText += chatLine(player2Start, player2,"Gonna be honest, I think they are " + this.generateNewOpinion(r2crush)  + ".");
					chatText += chatLine(player2Start, player2,"Sure you can't do better?");
					chatText += chatLine(player1Start, player1,"Screw you, you're just jealous.");
					r1.decrease();
				}else{  //try to ignore feelings
					chatText += chatLine(player2Start, player2,"Oh?");
					chatText += chatLine(player2Start, player2,"Congratulations?");
					chatText += chatLine(player2Start, player2,"I wish you the best of luck.");
					chatText += chatLine(player1Start, player1,"Thank you!");
				}
			}else{  //friend has no particular opinion about the crush.
				if(r2crush && r2.saved_type == r2crush.goodBig){  //but has a crush on the player (du-DUH!)
					//try to put aside feelings
					if(player2.class_name == "Page" || player2.class_name == "Maid" || player2.class_name == "Sylph" || player2.aspect == "Blood"){
						chatText += chatLine(player2Start, player2,"Wow! You should definitely, definitely tell them that! Right away!");
						chatText += chatLine(player1Start, player1,"You think so?");
						chatText += chatLine(player2Start, player2,"Absolutely.");
					}else if(player2.class_name == "Knight" || player2.class_name == "Seer" || player2.class_name == "Heir" || player2.aspect == "Mind"){ //fight player1
						chatText += chatLine(player2Start, player2,"Fuck! Um... Okay, I hate to do this to you...but...I think you're " + this.generateNewOpinion(r2) + ".");
						chatText += chatLine(player1Start, player1,"Oh!");
						chatText += chatLine(player1Start, player1,"Um...");
						if(r1.saved_type == r1.goodBig){
							chatText += chatLine(player1Start, player1,"I... kind of like you, too?");
							chatText += chatLine(player1Start, player1,"I assumed you wouldn't like me back, God, this is so awkward.");
							chatText += chatLine(player2Start, player2,"Holy shit.");
							makeHeart(player1, player2);
						}else{
							chatText += chatLine(player1Start, player1,"Fuck. I'm sorry. I just don't feel that way about you. ");
							chatText += chatLine(player2Start, player2,"Yeah. I kind of figured. But, I wanted to get that off my chest. ");
						}
					}else{  //try to ignore feelings
						chatText += chatLine(player2Start, player2,"Oh?");
						chatText += chatLine(player2Start, player2,"That's cool.");
						chatText += chatLine(player2Start, player2,"Yeah, that sure is a thing you just confided to me.");
						chatText += chatLine(player2Start, player2,"Glad you can trust me with this?");
						chatText += chatLine(player1Start, player1,"I couldn't keep it bottled up anymore...");
					}
				}else{  //generic advice
					chatText += chatLine(player2Start, player2,"Cool! What do you like about them?");
					var trait = whatDoPlayersHaveInCommon(player1, crush);
					chatText += chatLine(player1Start, player1,"They are just so...so...so " + trait);
					if(trait != "nice"){
						chatText += chatLine(player2Start, player2,"Heh, they sound perfect for you, then.");
						chatText += chatLine(player1Start, player1,"Thanks!");
					}else{
						chatText += chatLine(player2Start, player2,"Huh. Do you actually KNOW anything about them?");
						chatText += chatLine(player1Start, player1,"I'm getting there!");
					}

					//TODO maybe have another scene where they get a second chance at confessing, even if it's not fresh drama?
				}
			}
		}
		drawChat(canvasDiv, player1, player2, chatText, 1000,"discuss_romance.png");
	}

	//goes different if best friend has crush on player
	//or on jerk.
	//if no one to vent about, narrate, but mention lonliness. no trigger reduction.
	this.ventAboutJerk = function(div,player,jerk){
		var relationship = player.getRelationshipWith(jerk);
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;


		var chatText = "";
		var player1 = player;
		var player2 = this.getBestFriendBesidesCrush(player, jerk); //allowing them to be dead is funny

		if(player2 == null){
			var narration = "<br>The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			if(jerk.dead == true){
				narration += " It's hard for the " + player.htmlTitle() + " to care that they died.";
			}
			narration += " It's a shame the " + player.htmlTitle() + " has nobody to talk to about this. ";
			div.append(narration);
			return;
		}

		if(player2.dead == true){
			return this.corpseVent(div,player1,player2, jerk);
		}
		removeFromArray(player2, this.session.availablePlayers);
		var divID = (div.attr("id")) + "_" + player.chatHandle+"vent_jerk_"+jerk.chatHandle +  player.id;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		player.sanity += 3;  //talking about it helps.
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);
		var r2jerk = player2.getRelationshipWith(jerk);
		if(!r2jerk){
			console.log("I am : " + player2.title() + " and jerk is: " + jerk.title() + " and apparently I don't know them. ")
		}
		var chatText = "";
		var trait = whatDontPlayersHaveInCommon(player1, jerk);
		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"Oh my god, I can't STAND " + jerk.chatHandle + ", they are " + this.generateNewOpinion(r1) + ", you know?");
		if(jerk.dead == true){
			chatText += chatLine(player2Start, player2,"Do you really want to speak ill of the dead?");
			if( r2jerk && r2jerk.value < 0){
				chatText += chatLine(player2Start, player2,"But yeah, they were an asshole.");
				chatText += chatLine(player1Start, player1,"I know, right?");
			}else{
				chatText += chatLine(player1Start, player1,"Yeah, I kind of feel like an asshole, now");
			}
		}else{
			if(r2jerk && r2jerk.saved_type == r2jerk.badBig){
				chatText += chatLine(player2Start, player2,"Oh my god, I know, right?");
				chatText += chatLine(player2Start, player2,"I can't freaking stand them.");
				chatText += chatLine(player1Start, player1,"Represent.");
			}else if(r2jerk && r2jerk.saved_type == r2jerk.goodBig){
				chatText += chatLine(player2Start, player2,"!");
				chatText += chatLine(player2Start, player2,"Really?");
				chatText += chatLine(player2Start, player2,"I like them okay...");
				chatText += chatLine(player1Start, player1,"Great, now I have to question all your life decisions.");
			}else{
				chatText += chatLine(player2Start, player2,"Eh, they're okay.");
				if(player2.isTroll == false && player1.isTroll == true){
					chatText += chatLine(player2Start, player2,"Wait!  Is this a spades thing? That's a thing trolls do, right?");
					chatText += chatLine(player1Start, player1,"Oh. My. God. Just because I am a troll doesn't mean I have a black crush on every asshole that passes by.");
					chatText += chatLine(player2Start, player2,"Geez, sorry...");
				}else if(player2.isTroll == true && player1.isTroll == false){
					chatText += chatLine(player2Start, player2,"If that's what you're into, I mean. I can't see it.");
					chatText += chatLine(player1Start, player1,"Wait, what? Oh! No! Geez, I'm HUMAN, remember!? I do NOT have some weird troll crush on this " + trait + " asshole.");
					chatText += chatLine(player2Start, player2,"Geez, sorry...");
				}else{
					chatText += chatLine(player2Start, player2,"Why do you hate them so much?");

					chatText += chatLine(player1Start, player1,"They are just so... so... " + trait +"! That's all there is to say on the matter.");
					if(player2.isTroll == true && player1.isTroll == true){
						chatText += chatLine(player2Start, player2,"Whatever floats your boat.");
						chatText += chatLine(player1Start, player1,"Oh god... is this really coming off as a black crush?");
						chatText += chatLine(player1Start, player1,"Fuck. I hope it's not one.");
					}
				}
			}
		}
		drawChat(canvasDiv, player1, player2, chatText, 1000,"discuss_hatemance.png");

	}

	//notice if they are dead.
	this.antagonizeJerk = function(div,player,jerk){
		//debug("antagonizing a jerk.") //is this ever even happening???
		var relationship = player.getRelationshipWith(jerk);
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;



		if(jerk.dead == true){
			var narration = "<br>The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
			narration += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";
			narration += "It's hard for the " + player.htmlTitle() + " to care that they died.";
			div.append(narration);
			return;
		}
		removeFromArray(jerk, this.session.availablePlayers);
		var divID = (div.attr("id")) + "_" + player.chatHandle+"antagonize_jerk_"+jerk.chatHandle + player.id;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var canvasDiv = document.getElementById("canvas"+ divID);
		//different format for canvas code
		var chatText = "";
		var player1 = player;
		var player2 = jerk;
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = relationship;
		var r2 = player2.getRelationshipWith(player1);
		var chatText = "";

		chatText += chatLine(player1Start, player1,getRelationshipFlavorGreeting(r1, r2, player1, player2))
		chatText += chatLine(player2Start, player2,getRelationshipFlavorGreeting(r2, r1, player2, player1))
		chatText += chatLine(player1Start, player1,"You are " + this.generateNewOpinion(r1) + ", you know that?");
		r2.decrease();
		if(r2.saved_type == r2.badBig){
			chatText += chatLine(player2Start, player2,"The feeling is mutual, asshole. ");
			chatText += chatLine(player2Start, player2,"You are " + this.generateNewOpinion(r2) + ", times a million.");
			var trait = whatDontPlayersHaveInCommon(player1, player2);
			var trait2 = whatDontPlayersHaveInCommon(player2, player1);
			chatText += chatLine(player1Start, player1,"God, why are you so " + trait + "?");
			chatText += chatLine(player2Start, player2,"Fuck you, at least I'm not " + trait2 + "!");
			makeSpades(player1, player2);
			this.session.hasSpades = true;
			if(Math.seededRandom() > .5){
				this.celebratoryRapBattle(div, player1, player2);
			}

		}else if(r2.type == r2.goodBig){
			chatText += chatLine(player2Start, player2,"Wow. Yes. Way to be an asshole. ");
			var trait = whatDontPlayersHaveInCommon(player1, player2);
			chatText += chatLine(player1Start, player1,"God, why are you so " + trait + "?");
			chatText += chatLine(player2Start, player2,"And that's my cue to leave this chat. ");
			r2.decrease();
			r2.decrease();//broken heart
		}else{
			chatText += chatLine(player2Start, player2,"Holy shit. ");
			chatText += chatLine(player2Start, player2,"And here I thought you were " + this.generateNewOpinion(r2) + ".");
			if(player2.isTroll == true){
				chatText += chatLine(player2Start, player2,"I just don't hate you enough. ");
				if(player1.isTroll == true){
					chatText += chatLine(player1Start, player1,"Fuck.");
				}else{
					chatText += chatLine(player1Start, player1,"Wait. What!? Oh GOD, no! I am a HUMAN you dumb fuck! I DO NOT HAVE A CRUSH ON YOU!");
				}
			}else{
				if(player1.isTroll == true){
					chatText += chatLine(player1Start, player1,"Fuck.");
				}
			}
		}
		drawRelationshipChat(canvasDiv, player1, player2, chatText, 1000);
	}

	//funnier if they text a corpse
	this.getBestFriendBesidesCrush  = function(player, crush){
		var living = findLivingPlayers(this.session.players)
		var dead = findDeadPlayers(this.session.players);
		var players = living;
		players = players.concat(dead);
		//console.log("living: " + living.length + "dead: " + dead.length + " both: " + players.length);
		//alert("removing crush: " + crush.title() + " from array: " + living.length)
		removeFromArray(crush, players)
		//alert("removed crush: " + crush.title() + " from array: " + living.length)
		if(players.length>0){
			return player.getBestFriendFromList(players,"getLivingBestFriendBesidesCrush"+players);
		}
		return null;
	}

	this.getLivingBestFriendBesidesCrush = function(player,crush){
		var living = findLivingPlayers(this.session.players)
		//alert("removing crush: " + crush.title() + " from array: " + living.length)
		removeFromArray(crush, living)
		//alert("removed crush: " + crush.title() + " from array: " + living.length)
		if(living.length>0){
			return player.getBestFriendFromList(living,"getLivingBestFriendBesidesCrush"+living);
		}
		return null;
	}


		/*
	  //if too triggered and you have a crush on someone, don't message them directly
	  //instead chat up a friend (if you have one) and ask for advice. that will lower trigger level
	  //and NEXT time you should be able to talk to them.  drama only disabled once you talk to them.
	  //or stop liking them.

	  //if you have a new enemy, and not triggered enough, you can talk to a friend to try to cool down.
	  //if you have a new enemy and are triggered, you will taunt them.
	  //either way, drama disabled.

	  the person you vent to needs to be alive and NOT the person you are having drama with

	  claspect matters for how triggered you need to be, maybe?

	  //figure out what to do for other relationship types.
	*/
	this.renderForPlayer = function (div, player){
		var player1 = player;
		var relationships = player.getRelationshipDrama();

		for(var j = 0; j<relationships.length; j++){
			var r = relationships[j];
			if(r.type() == r.goodBig){
				if(player.sanity > 1){
					this.confessFeelings(div, player, r.target)
				}else{
					this.relationshipAdvice(div, player, r.target)
				}
			}else if(r.type() == r.badBig){
				if(player.sanity > 1){
					this.ventAboutJerk(div, player, r.target)
				}else{
					this.antagonizeJerk(div, player, r.target) //not thinking clearly, gonna start shit.
				}
			}else{
				//narration. but is it really worth it for something so small?
				//debug("tiny drama")
			}

		}


		/*
		for(var j = 0; j<relationships.length; j++){
				this.processDrama(player, relationships[j]);  //or drama dnever leaves
		}

		if(!player2){
			return div.append(this.content() + " Too bad the " + player.htmlTitle() + " doesn't have anybody to talk to about this. ");
		}
		var repeatTime = 1000;


		var divID = (div.attr("id")) + "_" + player1.chatHandle;
		var canvasHTML = "<br><canvas id='canvas" + divID+"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		//different format for canvas code
		var canvasDiv = document.getElementById("canvas"+ divID);
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var r1 = player1.getRelationshipWith(player2);
		var r2 = player2.getRelationshipWith(player1);

		var chatText = "";
		var relationship = relationships[0]
		chatText += chatLine(player1Start, player1, "TODO: Relationship stuff. I used to think " + player2.chatHandleShort() + " was " +this.generateOldOpinion(relationship ));
		if(relationship.target == player2){
			chatText += chatLine(player1Start, player1, "So...hey.");
			chatText += chatLine(player2Start, player2, "Hey?");
			chatText += chatLine(player1Start, player1, "I have no idea how to say this so I'm just going to do it.");
			chatText += chatLine(player1Start, player1, "I used to think you were "+ this.generateOldOpinion(relationship ));
			chatText += chatLine(player2Start, player2, "?");
			chatText += chatLine(player1Start, player1, "But now....");
			//maybe have different things happen here based on class?
			chatText += chatLine(player1Start, player1, "Fuck, this is too hard. Nevermind.");
		}
		drawChat(canvasDiv, player1, player2, chatText, repeatTime);
		*/
	}

	this.renderContent = function(div){
		//div.append(this.content());
		for(var i = 0; i<this.dramaPlayers.length; i++){
				var p = this.dramaPlayers[i];
				//take up time for other player once i know who they are.
				removeFromArray(p, this.session.availablePlayers); //how did i forget to make this take a turn? that's the whole point, romance distracts you from shit. won't make it distract your partner, tho.
				this.renderForPlayer(div, p);
			}

	}

	this.matchTypeToOpinion = function(type, relationship){
		if(type == relationship.badBig){
			return getRandomElementFromArray(bigBadDesc);
		}

		if(type == relationship.badMild){
			return getRandomElementFromArray(bigMildDesc);
		}

		if(type == relationship.goodBig){
			return getRandomElementFromArray(goodBigDesc);
		}

		if(type == relationship.goodMild){;
			return getRandomElementFromArray(goodMildDesc);
		}

		return "okay"
	}

	this.generateOldOpinion = function(relationship){
		return this.matchTypeToOpinion(relationship.old_type, relationship);
	}

	this.generateNewOpinion = function(relationship){
		return this.matchTypeToOpinion(relationship.saved_type, relationship);
	}

	/*
		this.saved_type = "";
	this.drama = false; //drama is set to true if type of relationship changes.
	this.old_type = "";
	this.goodMild = "Friends";
	this.goodBig = "Totally In Love";
	this.badMild = "Rivals";
	this.badBig = "Enemies";
	*/
	this.processDrama = function(player, relationship){
		var ret = "<img src = 'images/sceneIcons/heart_icon.png'> The " + player.htmlTitle() + " used to think that the " + relationship.target.htmlTitle() + " was ";
		ret += this.generateOldOpinion(relationship) + ", but now they can't help but think they are " + this.generateNewOpinion(relationship) + ".";

		if(relationship.saved_type == relationship.goodBig && relationship.target.dead){
			player.sanity += -10;
			ret += " They are especially devestated to realize this only after the " + relationship.target.htmlTitle() + " died. ";
		}
		relationship.drama = false; //it is consumed.
		relationship.old_type = relationship.saved_type;
		return ret;

	}

	this.content = function(){
		//describe what the drama is.  if the drama player is dead, skip.  if their target is dead, comment on that. (extra drama.  Only when he is a corpse do you realize...you love him.)
		var ret = " ";
		if(this.dramaPlayers.length > 2){
			ret += " So much drama has been going on. You don't even know. ";
		}
		for(var i = 0; i< this.dramaPlayers.length; i++){
			var p = this.dramaPlayers[i];
			var relationships = p.getRelationshipDrama();
			for(var j = 0; j<relationships.length; j++){
				ret += this.processDrama(p, relationships[j]);
			}

		}
		return ret;
	}
}
