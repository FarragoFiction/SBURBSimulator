function Breakup(session){
	this.session=session;
	this.canRepeat = false;
	this.player = null;
	this.relationshipToBreakUp = null;
	this.reason = "";
	//only can happen for one player at a time.
	//
	this.trigger = function(){
		this.player = null;
		this.relationshipToBreakUp = null;
		for(var i = 0; i<this.session.availablePlayers.length; i++){
			this.player = this.session.availablePlayers[i];
			return this.breakUpBecauseIAmCheating() || this.breakUpBecauseTheyCheating() || this.breakUpBecauseNotFeelingIt();
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
				this.relationshipToBreakUp.target.triggerLevel ++;
				this.relationshipToBreakUp.value += -1;
				this.reason = "me_cheat"
				console.log("breaking up hearts because i am cheating in session: " +this.session.session_id)
				return true;
			}
		}
		
		var spades = this.player.getSpades();
		if(spades.length > 1){
			if(Math.seededRandom()*3 < breakUpChance){
				this.relationshipToBreakUp = getRandomElementFromArray(spades);
				this.relationshipToBreakUp.target.triggerLevel ++;
				this.relationshipToBreakUp.value += -1;
				this.reason = "me_cheat"
				console.log("breaking up spades because i am cheating in session: " +this.session.session_id)
				return true;
			}
		}
		var diamonds =  this.player.getDiamonds();
		if(diamonds.length > 1){
			if(Math.seededRandom()*3 < breakUpChance){
				this.relationshipToBreakUp = getRandomElementFromArray(diamonds);
				//cheating with diamonds sounds like a terrible idea.
				this.relationshipToBreakUp.target.triggerLevel += 10;
				this.relationshipToBreakUp.value += -10;
				this.reason = "me_cheat"
				console.log("breaking up diamonds because i am cheating in session: " +this.session.session_id)
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
						//not happy with cheating bastards.
						this.player.triggerLevel += 10;
						r.value += -5;
						this.reason = "you_cheat"
						console.log("breaking up hearts because they are cheating in session: " +this.session.session_id)
						return true;
					}
				}
			}
			
			if(r.saved_type ==r.spades){
				var spades = r.target.getSpades();
				if(spades.length > 1){
					if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						//not happy with cheating bastards.
						this.player.triggerLevel += 10;
						r.value += -5;
						this.reason = "you_cheat"
						console.log("breaking up spades because they are cheating in session: " +this.session.session_id)
						return true;
					}
				}
			}
			
			if(r.saved_type ==r.diamond){
				var diamonds = r.target.getDiamonds();
				if(diamonds.length > 1){
					if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						//dude, cheating on diamonds sounds like a TERRIBLE idea.
						this.player.triggerLevel += 100;
						r.value += -50;
						this.reason = "you_cheat"
						console.log("breaking up diamonds because they are cheating in session: " +this.session.session_id)
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
						this.reason = "bored"
						console.log("breaking up heart because they are bored in session: " +this.session.session_id)
						return true;
				}
			}
			
			if(r.saved_type ==r.spades && realType != r.badBig ){
				if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp =r;
						this.reason = "bored"
						console.log("breaking up spades because they are bored in session: " +this.session.session_id)
						return true;
				}
			}
			
			if(r.saved_type ==r.diamond && r.value < 0 ){
				if(Math.seededRandom()*3 < breakUpChance){
						this.relationshipToBreakUp = r;
						this.reason = "bored"
						console.log("breaking up diamond because they are bored in session: " +this.session.session_id)
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
		
	


	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.content = function(){
		this.relationshipToBreakUp.saved_type = this.relationshipToBreakUp.changeType();
		this.relationshipToBreakUp.old_type = this.relationshipToBreakUp.saved_type;
		var oppRelationship = this.relationshipToBreakUp.target.getRelationshipWith(this.player);
		oppRelationship.saved_type = this.relationshipToBreakUp.changeType();
		oppRelationship.old_type = this.relationshipToBreakUp.saved_type;
		var ret = "TODO: Render BREAKUP between " + this.player.title() + " and " + this.relationshipToBreakUp.target.title() + " because " + this.reason ;
		return ret;
	}


}
