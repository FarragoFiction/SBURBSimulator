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
		var hearts = [];
		var spades = [];
		var diamonds = [];
	}
	//sets this.relationshipToBreakUp and returns true/false
	this.breakUpBecauseTheyCheating = function(){
		var hearts = [];
		var spades = [];
		var diamonds = [];
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
