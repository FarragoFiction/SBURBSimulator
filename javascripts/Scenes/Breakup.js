function Breakup(session){
	this.session=session;
	this.canRepeat = false;
	this.player = null;
	this.relationshipToBreakUp = null;
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
		//more likely if prospit, because they don't think secrets stay secret very long.
		var hearts = [];
		var spades = [];
		var diamonds = [];
		for (var i = 0; i<this.player.relationships.length; i++){
			var r = this.player.relationships[i];
			if(r.saved_type == r.heart){
				hearts.push(r);
			}else if(r.saved_type == r.diamond){
				diamonds.push(r);
			}else if(r.saved_type == r.spades){
				spades.push(r);
			}
		}
		//higher = more likely to break up if i'm given a reason.
		var breakUpChance = this.getModifierForAspect() + this.getModifierForClass() + this.getModifierForInterestsAdmitCheating(); //returns min value of .3
		if(hearts.length > 1){
			if(Math.seededRandom()*3 < breakUpChance){
				this.relationshipToBreakUp = getRandomElementFromArray(hearts);
				return true;
			}
		}else if(spades.length > 1){
			if(Math.seededRandom()*3 < breakUpChance){
				this.relationshipToBreakUp = getRandomElementFromArray(spades);
				return true;
			}
		}else if(diamonds.length > 1){
			if(Math.seededRandom()*3 < breakUpChance){
				this.relationshipToBreakUp = getRandomElementFromArray(diamonds);
				return true;
			}
		}
	}
	//sets this.relationshipToBreakUp and returns true/false
	this.breakUpBecauseTheyCheating = function(){
		//more likely if derse, horrorterrors tell you terrible things.
		var hearts = [];
		var spades = [];
		var diamonds = [];
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
		if(this.player.aspect == "Doom" ||  this.player.aspect == "Rage" ||this.player.aspect == "Breath" ||this.player.aspect == "Light" ||this.player.aspect == "Heart" ||this.player.aspect == "Mind" ||){
			return 1;
		}
		return 0;
	}
	
	//terrible people are way less likely to admit they are cheating.
	this.getModifierForInterestsAdmitCheating = function(){
		if(playerLikesTerrible(this.player)){
			return -12;
		}else{if(playerLikesSocial(this.player) || playerLikesRomantic(this.player) || playerLikesJustice(this.player){
			return 1;
		}
		return 0.1;
	}
	
	this.getModifierForInterestsAccuseCheating = function(){
		if(playerLikesTerrible(this.player)){
			return 2;
		}else if(playerLikesPopculture(this.player) || playerLikesJustice(this.player)){  //the TV always makes breakups dramatic, right?
			return 1;
		}else if(playerLikesDomestic(this.player){  //care more about stability.
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
		
	
	//sets this.relationshipToBreakUp and returns true/false
	this.breakUpBecauseNotFeelingIt = function(){
		//r.this.potentialBreakup() if saved type and old type differ, make old_type saved type and break up.
	}
	

	this.renderContent = function(div){
		div.append("<br>"+this.content());
	}

	this.content = function(){
		var ret = "TODO: BREAKUP between " + this.player.title() + " and " + this.relationshipToBreakUp.target.title();
		return ret;
	}


}
