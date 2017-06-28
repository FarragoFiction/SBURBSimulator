function Breakup(session){
	this.session=session;
	this.canRepeat = false;
	this.player = null;
	this.relationshipToBreakUp = null;
	this.reason = "";
	this.formerQuadrant = ""; //who are you cheating with?
	//only can happen for one player at a time.
	//
	this.trigger = function(){
		this.player = null;
		this.relationshipToBreakUp = null;
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			this.player = this.session.availablePlayers[i];
			var breakup= this.breakUpBecauseIAmCheating() || this.breakUpBecauseTheyCheating() || this.breakUpBecauseNotFeelingIt();
			if(!this.player.dead && breakup==true){
				//console.log("breakup happening: is it triggering anything??? " + this.reason + " with player: " + this.player.title() + this.session.session_id)
				return true;
			}
		}
		this.player = null;
		return false;
	}

	//sets this.relationshipToBreakUp and returns true/false
	this.breakUpBecauseIAmCheating = function(){
		//higher = more likely to break up if i'm given a reason.
		var breakUpChance = this.getModifierForAspect() + this.getModifierForClass() + this.getModifierForInterestsAdmitCheating(); //returns min value of .3
		//more likely if prospit, because they don't think secrets stay secret very long.
		if(this.player.moon == "Prospit"){
			breakUpChance += 1;
		}

		var hearts = this.player.getHearts();
		if(hearts.length > 1){
			if(Math.seededRandom()*3 < breakUpChance){
				this.relationshipToBreakUp = getRandomElementFromArray(hearts);
				this.formerQuadrant = this.relationshipToBreakUp.saved_type;
				this.relationshipToBreakUp.target.sanity += -10;
				this.relationshipToBreakUp.target.flipOut("getting cheated on by their Matesprit, the  " + this.player.htmlTitle() );
				var oppr = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
				oppr.value = 5;
				this.reason = "me_cheat"

				//console.log("breaking up hearts because i am cheating in session: " +this.session.session_id)
				return true;
			}
		}

		var spades = this.player.getSpades();
		if(spades.length > 1){
			if(Math.seededRandom()*3 < breakUpChance){
				this.relationshipToBreakUp = getRandomElementFromArray(spades);
				this.formerQuadrant = this.relationshipToBreakUp.saved_type;
				this.relationshipToBreakUp.target.sanity += -10;
				this.relationshipToBreakUp.target.flipOut("getting cheated on by their Kismesis, the  " + this.player.htmlTitle() );
				var oppr = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
				oppr.value = 5;
				this.reason = "me_cheat"
				//console.log("breaking up spades because i am cheating in session: " +this.session.session_id)
				return true;
			}
		}
		var diamonds =  this.player.getDiamonds();
		if(diamonds.length > 1){
			if(Math.seededRandom()*3 < breakUpChance){
				this.relationshipToBreakUp = getRandomElementFromArray(diamonds);
				this.formerQuadrant = this.relationshipToBreakUp.saved_type;
				//cheating with diamonds sounds like a terrible idea.
				this.relationshipToBreakUp.target.sanity += -100;
				this.relationshipToBreakUp.target.flipOut("getting cheated on by their Moirail, the  " + this.player.htmlTitle() );
				var oppr = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
				oppr.value = -1;
				this.reason = "me_cheat"
				//console.log("breaking up diamonds because i am cheating in session: " +this.session.session_id)
				return true;
			}
		}
	}
	//sets this.relationshipToBreakUp and returns true/false
	this.breakUpBecauseTheyCheating = function(){
		//higher = more likely to break up if i'm given a reason.
		var breakUpChance = this.getModifierForAspect() + this.getModifierForClass() + this.getModifierForInterestsAccuseCheating(); //returns min value of .3
		//more likely if derse, horrorterrors tell you terrible things.
		if(this.player.moon == "Derse"){
			breakUpChance += 1;
		}

		for (var i = 0; i<this.player.relationships.length; i++){
			var r = this.player.relationships[i];
			if(r.saved_type ==r.heart){
				var hearts = r.target.getHearts();
				if(hearts.length > 1){
					if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						//not happy with cheating bastards.
						this.player.sanity += -100;
						this.player.flipOut("having to confront their Matesprit, the  " + this.relationshipToBreakUp.target.htmlTitle() + " about their cheating");
						r.value =-10;
						this.reason = "you_cheat"
						//console.log("breaking up hearts because they are cheating in session: " +this.session.session_id)
						return true;
					}
				}
			}

			if(r.saved_type ==r.spades){
				var spades = r.target.getSpades();
				if(spades.length > 1){
					if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						//not happy with cheating bastards.
						this.player.sanity += -100;
						this.player.flipOut("having to confront their Kismesis, the  " + this.relationshipToBreakUp.target.htmlTitle() + " about their cheating");
						r.value =-10;
						this.reason = "you_cheat"
						//console.log("breaking up spades because they are cheating in session: " +this.session.session_id)
						return true;
					}
				}
			}

			if(r.saved_type ==r.diamond){
				var diamonds = r.target.getDiamonds();
				if(diamonds.length > 1){
					if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						//dude, cheating on diamonds sounds like a TERRIBLE idea.
						this.player.sanity += -1000;
						this.relationshipToBreakUp.target.flipOut("having to confront their trusted FUCKING Moirail, the  " + this.relationshipToBreakUp.target.htmlTitle() + " about their cheating");
						r.value =-50;
						this.reason = "you_cheat"
						//console.log("breaking up diamonds because they are cheating in session: " +this.session.session_id)
						return true;
					}
				}
			}
		}
	}

	//sets this.relationshipToBreakUp and returns true/false
	this.breakUpBecauseNotFeelingIt = function(){
		var breakUpChance = this.getModifierForAspect() + this.getModifierForClass() + this.getModifierForInterestsBored(); //returns min value of .3
		for (var i = 0; i<this.player.relationships.length; i++){
			var r = this.player.relationships[i];
			var realType = r.changeType(); //doesn't save anything.
			if(r.saved_type ==r.heart && realType != r.goodBig ){
				if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						this.reason = "bored"
						//console.log("breaking up heart because they are bored in session: " +this.session.session_id)
						return true;
				}
			}

			if(r.saved_type ==r.spades && realType != r.badBig ){
				if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp =r;
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
						this.reason = "bored"
					//	console.log("breaking up spades because they are bored in session: " +this.session.session_id)
						return true;
				}
			}

			if(r.saved_type ==r.diamond && r.value < 0 ){
				if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.reason = "bored"
						this.formerQuadrant = this.relationshipToBreakUp.saved_type;
					//	console.log("breaking up diamond because they are bored in session: " +this.session.session_id)
						return true;
				}
			}
		}

	}



	//active classes more likely to take action.
	this.getModifierForClass = function(){
		if(this.player.class_name == "Thief" || this.player.class_name == "Knight" || this.player.class_name == "Heir"|| this.player.class_name == "Seer"|| this.player.class_name == "Witch"|| this.player.class_name == "Prince"){
			return 1;
		}
		return 0;
	}
	//how likely are you to cause change?
	this.getModifierForAspect = function(){
		if(this.player.aspect == "Doom" ||  this.player.aspect == "Rage" ||this.player.aspect == "Breath" ||this.player.aspect == "Light" ||this.player.aspect == "Heart" ||this.player.aspect == "Mind" ){
			return 1;
		}
		return 0;
	}

	//terrible people are way less likely to admit they are cheating.
	this.getModifierForInterestsAdmitCheating = function(){
		if(playerLikesTerrible(this.player)){
			return -12;
		}else if(playerLikesSocial(this.player) || playerLikesRomantic(this.player) || playerLikesJustice(this.player)){
			return 1;
		}
		return 0.1;
	}

	this.getModifierForInterestsAccuseCheating = function(){
		if(playerLikesTerrible(this.player)){
			return 2;
		}else if(playerLikesPopculture(this.player) || playerLikesJustice(this.player)){  //the TV always makes breakups dramatic, right?
			return 1;
		}else if(playerLikesDomestic(this.player)){  //care more about stability.
			return -1;
		}
		return 0.1;
	}

	//terrible people have a very low threshold for being bored. if they are no longer feeling it, they are GON-E.
	this.getModifierForInterestsBored = function(){
		if(playerLikesTerrible(this.player)){
			return 12;
		}else if(playerLikesPopculture(this.player) || playerLikesTechnology(this.player)){
			return 1;
		}
		return 0.1;
	}

	//different chats for different this.reason
	this.getChat = function(player1, player2){
		if(this.reason == "me_cheat"){
			return this.meCheatChatText(player1, player2)
		}else if(this.reason == "you_cheat"){
			return this.youCheatChatText(player1, player2)
		}else{
			return this.meBoredChatText(player1, player2)
		}

	}

	this.breakupChat = function(div){
		//drawChat(canvasDiv, player1, player2, chatText, 1000,"discuss_hatemance.png");
		var canvasHTML = "<br><canvas id='canvas" + (div.attr("id")) +"' width='" +canvasWidth + "' height="+canvasHeight + "'>  </canvas>";
		div.append(canvasHTML);
		var player1 = this.player;
		var player2 = this.relationshipToBreakUp.target;
		var chatText = this.getChat(player1,player2);

		drawChat(document.getElementById("canvas"+ (div.attr("id"))), player1, player2, chatText, repeatTime,"discuss_breakup.png");
	}
  //formerQuadrant
	this.youCheatChatText = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		chatText += chatLine(player1Start, player1,"You. Asshole!");
		chatText += chatLine(player2Start, player2,"Hey?");
		var mocking = player2.quirk.translate("Hey");
		chatText += chatLine(player1Start, player1,"Don't '" + mocking + "' me. I know what you did. ");
		chatText += chatLine(player2Start, player2,"I have no idea what you are talking about!");
		var other = "";
		if(this.formerQuadrant == this.relationshipToBreakUp.heart){
			 other = player2.getHearts()[0].target.chatHandle;
		}else if(this.formerQuadrant == this.relationshipToBreakUp.diamond){
			other = player2.getDiamonds()[0].target.chatHandle;
		}else if(this.formerQuadrant == this.relationshipToBreakUp.spades){
			other = player2.getSpades()[0].target.chatHandle;
		}
		chatText += chatLine(player1Start, player1,"I know what you've been doing with " + other + ". ");
		chatText += chatLine(player2Start, player2,"Fuck.");
		chatText += chatLine(player1Start, player1,"It's over.");
		return chatText;

	}

	this.meCheatChatText = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		chatText += chatLine(player1Start, player1,"Um. Hey.");
		chatText += chatLine(player2Start, player2,"Hey?");
		chatText += chatLine(player1Start, player1,"Fuck. Why's this so hard?");
		chatText += chatLine(player1Start, player1,"How do I say this?");
		chatText += chatLine(player2Start, player2,"?");
		chatText += chatLine(player1Start, player1,"We need to break up.");
		chatText += chatLine(player2Start, player2,"What!?");
		var other = "";
		if(this.formerQuadrant == this.relationshipToBreakUp.heart){
			 other = player1.getHearts()[0].target.chatHandle;
		}else if(this.formerQuadrant == this.relationshipToBreakUp.diamond){
			other = player1.getDiamonds()[0].target.chatHandle;
		}else if(this.formerQuadrant == this.relationshipToBreakUp.spades){
			other = player1.getSpades()[0].target.chatHandle;
		}
		chatText += chatLine(player1Start, player1,"I didn't mean to hurt you. It just happened. But... I'm with " + other + " now. And I didn't want to keep stringing you along.");
		chatText += chatLine(player2Start, player2,"How could you!? I thought we were special!");
		chatText += chatLine(player1Start, player1,"I'm sorry.");

		return chatText;

	}

	//example of breakup language.
	//http://www.mspaintadventures.com/?s=6&p=009694
	//http://www.mspaintadventures.com/?s=6&p=009686
	this.meBoredChatText = function(player1, player2){
		var player1Start = player1.chatHandleShort()+ ": "
		var player2Start = player2.chatHandleShortCheckDup(player1.chatHandleShort())+ ": "; //don't be lazy and usePlayer1Start as input, there's a colon.
		var chatText = "";
		chatText += chatLine(player1Start, player1,"Um. Hey.");
		chatText += chatLine(player2Start, player2,"Hey?");
		chatText += chatLine(player1Start, player1,"Fuck. Why's this so hard?");
		chatText += chatLine(player2Start, player2,"?");
		chatText += chatLine(player1Start, player1,"We need to break up.");
		chatText += chatLine(player2Start, player2,"What!?");
		chatText += chatLine(player1Start, player1,"I just... don't feel the same way about you anymore. Maybe we changed too much.");
		chatText += chatLine(player1Start, player1,"I'm sorry. I can't keep pretending.");
		chatText += chatLine(player2Start, player2,"Wait! No! Let's talk about this!");
		chatText += chatLine(player1Start, player1,"I've made up my mind. I'm sorry. Goodbye.");

		return chatText;
	}




	this.renderContent = function(div){
		div.append("<br>"+this.content());
		//takes up time from both of them
		removeFromArray(this.player, this.session.availablePlayers);
		removeFromArray(this.relationshipToBreakUp.target, this.session.availablePlayers);
		if(this.relationshipToBreakUp.target.dead){
			//do nothing, just text
		}else{
			this.breakupChat(div);
		}

	}

	this.content = function(){
		this.relationshipToBreakUp.saved_type = this.relationshipToBreakUp.changeType();
		this.relationshipToBreakUp.old_type = this.relationshipToBreakUp.saved_type;
		var oppRelationship = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
		oppRelationship.saved_type = this.relationshipToBreakUp.changeType();
		oppRelationship.old_type = this.relationshipToBreakUp.saved_type;
		this.session.hasBreakups = true;  //lets AB report on the hot gos
		//var ret = "TODO: Render BREAKUP between " + this.player.title() + " and " + this.relationshipToBreakUp.target.title() + " because " + this.reason ;
		if(this.relationshipToBreakUp.target.dead){
			return "The " + this.player.htmlTitleBasic() + " has finally decided it is time to move on. The " + this.relationshipToBreakUp.target.htmlTitleBasic() + " is dead. They have mourned them long enough. ";
		}
		return "";
	}


}
